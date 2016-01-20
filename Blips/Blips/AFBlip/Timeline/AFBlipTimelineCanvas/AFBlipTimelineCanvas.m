//
//  AFBlipTimelineCanvas.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipTimelineCanvas.h"
#import "AFBlipTimelineCanvasCell.h"
#import "AFBlipTimelineHeader.h"
#import "AFBlipTimelineCanvasLayout.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoTimelineModel.h"
#import "AFBlipVideoModel.h"
#import "AFBlipUserModel.h"

#pragma mark - Constants
//Cells per page
const NSUInteger kAFBlipTimelineCanvas_CellLoadingThreholdIndex               = 7;

//Cell identifier
NSString *const kAFBlipTimelineCanvas_CellIdentifier                          = @"kAFBlipTimelineCanvasCellIdentifier";

//User ID Check
NSString *const kAFBlipUserIDCheck                                            = @"user_content/users/%@/profileImage/profileImage.jpg";

//Sizing
const CGFloat kAFBlipTimelineCanvas_CellMarkerWidth                           = 4.0f;
const CGFloat kAFBlipTimelineCanvas_CellMarkerHeight                          = 25.0f;
const CGFloat kAFBlipTimelineCanvas_CellMarkerAnimateInDuration               = 0.35f;
const CGFloat kAFBlipTimelineCanvas_CellMarkerAnimateOutDuration              = 0.15f;

//Animations
const CGFloat kAFBlipTimelineCanvas_CanvasAnimateInDuration                   = 0.3f;
const CGFloat kAFBlipTimelineCanvas_CanvasAnimateOutDuration                  = 0.25f;

//Initial load scroll offset
const CGFloat kAFBlipTimelineCanvas_CanvasInitialLoadScrollOffset             = - 50.0f;

//Header
const CGFloat kAFBlipTimelineCanvas_CanvasHeaderCenterPadding                 = 15.0f;

//Activity indicator
const NSTimeInterval kAFBlipTimelineCanvas_ActivityIndicatorShowHideAnimation = 0.3f;

@interface AFBlipTimelineCanvas () <UICollectionViewDelegate, UICollectionViewDataSource, AFBlipTimelineCanvasCellDelegate, AFBlipTimelineHeaderDelegate> {
    
    AFBlipTimelineHeader     *_header;
    AFBlipVideoTimelineModel *_timelineModel;
    AFBlipActivityIndicator  *_activityIndicator;
    UICollectionView         *_collectionView;
    UIView                   *_currentCellMarker;
    NSMutableArray           *_data;
}

@end

@implementation AFBlipTimelineCanvas

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
      
        self.clipsToBounds = YES;
        [self createCollectionView];
        [self createCurrentCellMarker];
        [self createHeader];
    }
    return self;
}

#pragma mark - Create collection view
- (void)createCollectionView {

    //Collection view layout
    CGFloat edgeInset                                = CGRectGetMidY(self.bounds) - ([AFBlipTimelineCanvasCell cellHeight] * 0.5f);

    AFBlipTimelineCanvasLayout *collectionViewLayout = [[AFBlipTimelineCanvasLayout alloc] init];
    collectionViewLayout.itemSize                    = CGSizeMake(self.bounds.size.width, [AFBlipTimelineCanvasCell cellHeight]);
    collectionViewLayout.sectionInset                = UIEdgeInsetsMake(edgeInset, 0, edgeInset, 0);

    //Collection view
    _collectionView                                  = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[AFBlipTimelineCanvasCell class] forCellWithReuseIdentifier:kAFBlipTimelineCanvas_CellIdentifier];
    _collectionView.backgroundColor                  = [UIColor clearColor];
    _collectionView.dataSource                       = self;
    _collectionView.delegate                         = self;
    _collectionView.showsVerticalScrollIndicator     = NO;
    _collectionView.alwaysBounceVertical             = YES;
    [self addSubview:_collectionView];
}

#pragma mark - Create current cell marker
- (void)createCurrentCellMarker {
    
    //Cell marker
    _currentCellMarker = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kAFBlipTimelineCanvas_CellMarkerWidth, (CGRectGetHeight(self.bounds) - kAFBlipTimelineCanvas_CellMarkerHeight) / 2, kAFBlipTimelineCanvas_CellMarkerWidth, kAFBlipTimelineCanvas_CellMarkerHeight)];
    _currentCellMarker.backgroundColor  = [UIColor afBlipOrangeSecondaryColor];
    [self addSubview:_currentCellMarker];
}

#pragma mark - Create header
- (void)createHeader {
    
    CGFloat headerHeight     = CGRectGetMidY(self.bounds) - ([AFBlipTimelineCanvasCell cellHeight] * 0.5f) - kAFBlipTimelineCanvas_CanvasHeaderCenterPadding;
    _header                  = [[AFBlipTimelineHeader alloc] initWithFrame:CGRectMake(0, - headerHeight, CGRectGetWidth(self.bounds), headerHeight)];
    _header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _header.delegate         = self;
    [self addSubview:_header];
}

#pragma mark - AFBlipTimelineHeaderDelegate
- (void)timelineHeaderDidSelectNewVideo:(AFBlipTimelineHeader *)timelineHeader {
    
    [_delegate timelineCanvas:self didSelectNewVideoWithVideoTimelineModel:_timelineModel];
}

- (void)timelineHeaderDidSelectDelete:(AFBlipTimelineHeader *)timelineHeader {
    
    [_delegate timelineCanvas:self didSelectDeleteFriend:_timelineModel.timelineUserId friendDisplayName:_timelineModel.timelineTitle];
}

- (void)timelineHeaderDidSelectRefresh:(AFBlipTimelineHeader *)timelineHeader {
    
    [_delegate timelineCanvasDidSelectRefresh:self];
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell
    AFBlipTimelineCanvasCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipTimelineCanvas_CellIdentifier forIndexPath:indexPath];
    
    if(!cell.delegate) {
        cell.delegate = self;
    }
    
    //Data
    AFBlipVideoModel *videoModel = [self dataAtIndexPath:indexPath];
    [cell setVideoModel:videoModel];
    
    [self checkForMoreData:indexPath.row];
        
    return cell;
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!_data || !_data.count) {
        return nil;
    }
    
    NSUInteger row = MIN(indexPath.row, _data.count);
    return _data[row];
}

- (void)checkForMoreData:(NSUInteger)row {
        
    //Call for appended data
    if(row > _data.count - kAFBlipTimelineCanvas_CellLoadingThreholdIndex) {
        [_delegate timelineCanvasWillReachEnd:self];
    } else if(row >= _data.count - 1) {
        [_delegate timelineCanvasDidReachEnd:self];
    }
}

#pragma mark - AFBlipTimelineCanvasCellDelegate
- (void)timelineCanvasCellDidPressProfile:(AFBlipTimelineCanvasCell *)cell {
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
    AFBlipVideoModel *videoModel = _data[indexPath.row];
    if (videoModel) {
        if (![videoModel.userThumbnailURLString isEqualToString:[NSString stringWithFormat:kAFBlipUserIDCheck, [[AFBlipUserModelSingleton sharedUserModel].userModel user_id]]]) {
            [_delegate timelineCanvas:self didSelectConnectionProfile:videoModel];
        }
    }
}

- (void)timelineCanvasCellDidPressVideo:(AFBlipTimelineCanvasCell *)cell {
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];

    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];

    AFBlipVideoModel *videoModel = _data[indexPath.row];
    [_delegate timelineCanvas:self didSelectVideo:videoModel videoTimelineModel:_timelineModel];
}

- (void)timelineCanvasCellDidFavouriteVideo:(AFBlipTimelineCanvasCell *)cell {
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];

    AFBlipVideoModel *videoModel = _data[indexPath.row];
    [_delegate timelineCanvas:self didSelectFavouriteVideo:videoModel];
}

- (void)timelineCanvasCellDidUnfavouriteVideo:(AFBlipTimelineCanvasCell *)cell {
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];

    AFBlipVideoModel *videoModel = _data[indexPath.row];
    [_delegate timelineCanvas:self didSelectUnfavouriteVideo:videoModel];
    
    //Update timeline if needed
    if([_delegate timelineCanvasShouldDeleteRowWhenUnfavourited:self]) {
        
        [_data removeObjectAtIndex:indexPath.row];
        
        //If the data array is empty then update the timeline header
        if(!_data.count) {
            
            _timelineModel.videos = nil;
            AFBlipUserModel *userModel = [AFBlipUserModelSingleton sharedUserModel].userModel;
            [self setData:nil userModel:userModel timelineModel:_timelineModel];
        } else {
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self scrollViewDidScroll:_collectionView];
        }
    }
}

- (void)deleteVideoModel:(AFBlipVideoModel *)videoModel {
    
    //Update timeline
    NSInteger index = [_data indexOfObject:videoModel];
    if(index == NSNotFound) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_data removeObject:videoModel];
    
    //If the data array is empty then update the timeline header
    if(!_data.count) {
        
        _timelineModel.videos = nil;
        AFBlipUserModel *userModel = [AFBlipUserModelSingleton sharedUserModel].userModel;
        [self setData:nil userModel:userModel timelineModel:_timelineModel];
    } else {
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [self scrollViewDidScroll:_collectionView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSTimeInterval duration;
    CGRect frame = _currentCellMarker.frame;

    if(scrollView.isDecelerating || scrollView.isDragging || !_data.count > 0) {
        
        duration       = kAFBlipTimelineCanvas_CellMarkerAnimateOutDuration;
        frame.origin.x = CGRectGetWidth(self.bounds);

    } else {
        
        duration = kAFBlipTimelineCanvas_CellMarkerAnimateInDuration;
        frame.origin.x = CGRectGetWidth(self.bounds) - kAFBlipTimelineCanvas_CellMarkerWidth;
    }
    
    if(!CGRectEqualToRect(_currentCellMarker.frame, frame)) {
        [UIView animateWithDuration:duration animations:^{
            
            _currentCellMarker.frame = frame;
        }];
    }
    
    //Header
    [_header setHeaderInternalPosY:_collectionView.contentOffset.y];
    
    //Parallax
    for(AFBlipTimelineCanvasCell *cell in _collectionView.visibleCells) {
        
        CGFloat position = [self parallaxPositionForCell:cell];
        [cell setParallaxPosition:position];
        [cell setNeedsLayout];
    }
}

- (CGFloat)parallaxPositionForCell:(UICollectionViewCell *)cell {
    
    static CGFloat minPos;
    static CGFloat maxPos;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        minPos = -1.0f;
        maxPos = 1.0f;
    
    });
    CGRect frame = cell.frame;
    const CGPoint point = [[cell superview] convertPoint:frame.origin toView:_collectionView];
    
    const CGFloat minY = CGRectGetMinY(_collectionView.bounds) - CGRectGetHeight(frame);
    const CGFloat maxY = CGRectGetMaxY(_collectionView.bounds);
    
    return (maxPos - minPos) / (maxY - minY) * (point.y - minY) + minPos;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self positionToCanvasCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if(!decelerate) {
        [self positionToCanvasCell];
    }
}

- (void)positionToCanvasCell {
    
    CGFloat posX = 0;
    CGFloat posY = _collectionView.center.y + _collectionView.contentOffset.y;
    NSIndexPath *cellIndexPath = [_collectionView indexPathForItemAtPoint:CGPointMake(posX, posY)];
    
    if(cellIndexPath) {
        [_collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
    
    [UIView animateWithDuration:kAFBlipTimelineCanvas_CellMarkerAnimateInDuration animations:^{
        
        CGRect frame = _currentCellMarker.frame;
        frame.origin.x = CGRectGetWidth(self.bounds) - kAFBlipTimelineCanvas_CellMarkerWidth;
        _currentCellMarker.frame = frame;
    }];
}

#pragma mark - Data handling
- (void)setData:(NSArray *)data userModel:(AFBlipUserModel *)userModel timelineModel:(AFBlipVideoTimelineModel *)timelineModel {
    
    _timelineModel = timelineModel;
    _data          = [NSMutableArray arrayWithArray:data];
    typeof(self) __weak wself = self;
    typeof(_collectionView) __weak weakCollectionView = _collectionView;
    typeof(_header) __weak weakHeader                 = _header;
    CGFloat __block weakHeaderMaxHeight               = _header.maxHeaderHeight;
    CGRect __block headerFrame                        = weakHeader.frame;
    headerFrame.size.height                           = weakHeaderMaxHeight;
    headerFrame.origin.y                              = - weakHeaderMaxHeight;
    
    //Animate timeline
    [UIView animateWithDuration:kAFBlipTimelineCanvas_CanvasAnimateOutDuration * 2 delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        weakHeader.frame         = headerFrame;
        weakCollectionView.alpha = 0;

    } completion:^(BOOL finished) {
        
        //Collection view
        [weakCollectionView setContentOffset:CGPointMake(0, kAFBlipTimelineCanvas_CanvasInitialLoadScrollOffset)];
        [weakCollectionView reloadData];
        [weakCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        //Header
        [weakHeader setTimelineModel:_timelineModel];
        
        weakHeader.frame        = headerFrame;
        headerFrame.origin.y    = 0;

        [UIView animateWithDuration:kAFBlipTimelineCanvas_CanvasAnimateInDuration * 2 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:10.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            weakCollectionView.alpha = 1;
            weakHeader.frame         = headerFrame;
        } completion:^(BOOL finished) {
            [wself showActivityIndicator:NO];
        }];
    }];
}

- (void)appendData:(NSArray *)data {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSUInteger totalDataCount  = _data.count;
        NSUInteger i               = 0;
        while(i < data.count) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + totalDataCount inSection:0];
            [indexPaths addObject:indexPath];
            i++;
        }
        
        [_data addObjectsFromArray:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView insertItemsAtIndexPaths:indexPaths];
        });
    });
}

- (void)reloadCellWithModel:(AFBlipVideoModel *)model {
    AFBlipTimelineCanvasCell *cell;
    NSIndexPath *indexPath;
    for (NSInteger i = 0; i < _data.count; i++) {
        if ([model isEqual:_data[i]]) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    
    if (indexPath) {
        cell = (AFBlipTimelineCanvasCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        [cell setVideoModel:model];
    }
    
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    [self showActivityIndicator:show animatedHeader:YES];
}

- (void)showActivityIndicator:(BOOL)show animatedHeader:(BOOL)animatedHeader {

    self.userInteractionEnabled = !show;
    [_header setRefreshing:show];
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = self.center;
    }
    
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    CGFloat collectionViewAlpha    = show ? 0.3f : 1.0f;

    [UIView animateWithDuration:kAFBlipTimelineCanvas_ActivityIndicatorShowHideAnimation animations:^{
        
        _collectionView.alpha    = collectionViewAlpha;
        
    } completion:nil];

    //Timeline header
    if(!show) {
        [_activityIndicator stopAnimating];
        return;
    }
    
    typeof(_header) __weak weakHeader   = _header;
    CGFloat __block weakHeaderMaxHeight = _header.maxHeaderHeight;
    CGRect __block headerFrame          = weakHeader.frame;
    headerFrame.size.height             = weakHeaderMaxHeight;
    headerFrame.origin.y                = - weakHeaderMaxHeight;

    [UIView animateWithDuration:kAFBlipTimelineCanvas_CanvasAnimateOutDuration * 2 delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        weakHeader.frame            = headerFrame;
    } completion:nil];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end