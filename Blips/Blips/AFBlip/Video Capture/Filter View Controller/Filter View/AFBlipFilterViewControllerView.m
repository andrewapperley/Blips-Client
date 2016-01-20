//
//  AFBlipFilterViewControllerView.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-02.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFilterViewControllerView.h"
#import "AFBlipFilterListCell.h"
#import "AFBlipFilterVideoModel.h"

static NSInteger kAFBlipFilterListHeight                            = 100;
const NSInteger kAFBlipFilterListMarginY                            = 0;

//Marker
const CGFloat kAFBlipFilterList_CellMarkerTopOffset                 = - 65.0f;
const CGFloat kAFBlipFilterList_CellMarkerWidth                     = 25.0f;
const CGFloat kAFBlipFilterList_CellMarkerHeight                    = 4.0f;
const CGFloat kAFBlipFilterList_ScreenOffsetHeight                  = 15.0f;
const NSTimeInterval kAFBlipFilterList_CellMarkerAnimateInDuration  = 0.35f;
const NSTimeInterval kAFBlipFilterList_CellMarkerAnimateOutDuration = 0.15f;
const NSTimeInterval kAFBlipFilterList_MotionEffectsAmount          = 10.0f;

@interface AFBlipFilterViewControllerView () <AFBlipFilterVideoPlayerDelegate, UICollectionViewDelegate> {
    
    AFBlipFilterVideoPlayer *_filterVideoPlayer;
    UICollectionView *_filterList;
    UIView           *_currentCellMarker;
    CGSize           _videoDimensions;
}

@end

@implementation AFBlipFilterViewControllerView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AFBlipFilterViewControllerViewDelegate>)delegate videoDimensions:(CGSize)videoSize {
    self = [super initWithFrame:frame];
    if (self) {
        if ([[UIScreen mainScreen]bounds].size.height < 568) {
            kAFBlipFilterListHeight = 90;
        }
        _videoDimensions = videoSize;
        _selectedFilterIndex = NSNotFound;
        _delegate = delegate;
        [self createFilterVideoPlayer];
        [self createFilterCollection];
        [self createCurrentCellMarker];
    }
    return self;
}

- (void)createFilterVideoPlayer {
    
    CGSize defaultSize    = defaultVideoPlayerSize();
    CGFloat padding       = (CGRectGetWidth(self.bounds) - defaultSize.width) / 2;
    CGRect frame          = CGRectMake(padding, padding, defaultSize.width, defaultSize.height);
    
    _filterVideoPlayer = [[AFBlipFilterVideoPlayer alloc] initWithFrame:frame delegate:self videoDimensions:_videoDimensions];
    
    [self addSubview:_filterVideoPlayer];
}

- (void)createFilterCollection {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(kAFBlipFilterListHeight, kAFBlipFilterListHeight)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(0,  (self.frame.size.width - kAFBlipFilterListHeight) / 2, 0, (self.frame.size.width - kAFBlipFilterListHeight) / 2)];
    
    CGFloat heightOfButtonArea = self.bounds.size.height - CGRectGetMaxY(_filterVideoPlayer.frame) - kAFBlipFilterList_ScreenOffsetHeight;
    CGFloat _filterListY = CGRectGetMaxY(_filterVideoPlayer.frame) - kAFBlipFilterList_ScreenOffsetHeight + ((heightOfButtonArea - kAFBlipFilterListHeight)/2);
    
    _filterList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _filterListY, self.frame.size.width, kAFBlipFilterListHeight) collectionViewLayout:layout];
    _filterList.backgroundColor = [UIColor clearColor];
    _filterList.clipsToBounds = NO;
    [_filterList setShowsHorizontalScrollIndicator:NO];
    [_filterList registerClass:[AFBlipFilterListCell class] forCellWithReuseIdentifier:kAFBlipFilterCellKey];
    _filterList.delegate = self;
    _filterList.dataSource = _filterVideoPlayer;
    [self addSubview:_filterList];
    
    UIMotionEffectGroup *motionEffects = [self createMotionEffectGroupWithMotionAmount:CGPointMake(kAFBlipFilterList_MotionEffectsAmount, kAFBlipFilterList_MotionEffectsAmount)];
    [_filterList addMotionEffect:motionEffects];
}

- (UIMotionEffectGroup *)createMotionEffectGroupWithMotionAmount:(CGPoint)motionAmount {
    
    //Horizontal effect
    UIInterpolatingMotionEffect *motionEffectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffectHorizontal.minimumRelativeValue         = @( - motionAmount.x);
    motionEffectHorizontal.maximumRelativeValue         = @( motionAmount.x);
    
    //Vertical effect
    UIInterpolatingMotionEffect *motionEffectVertical   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectVertical.minimumRelativeValue           = @( - motionAmount.y);
    motionEffectVertical.maximumRelativeValue           = @( motionAmount.y);
    
    UIMotionEffectGroup *motionEffectGroup              = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects                     = @[motionEffectHorizontal, motionEffectVertical];
    
    return motionEffectGroup;
}

#pragma mark - Create current cell marker
- (void)createCurrentCellMarker {
    
    //Cell marker
    _currentCellMarker = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - kAFBlipFilterList_CellMarkerWidth) / 2, CGRectGetHeight(self.bounds) + kAFBlipFilterList_CellMarkerTopOffset - kAFBlipFilterList_CellMarkerHeight, kAFBlipFilterList_CellMarkerWidth, kAFBlipFilterList_CellMarkerHeight)];
    _currentCellMarker.backgroundColor  = [UIColor afBlipOrangeSecondaryColor];
    [self addSubview:_currentCellMarker];
}

- (void)saveVideoFile:(AFBlipFilterSaveVideoCompletion)completion {
    self.userInteractionEnabled = NO;
    [_filterVideoPlayer saveVideoFile:^{
        self.userInteractionEnabled = YES;
        if (completion) {
            completion();
        }
    }];
}

- (void)selectDefaultFilter {
    
    NSString *selectedFilterName = [[NSUserDefaults standardUserDefaults] objectForKey:kAFBlipSelectedFilterKey];
    
    NSInteger filterIndex = 0;
    if(selectedFilterName) {
        for (NSInteger i = 0; i < _filterVideoPlayer.filterList.count; i++) {
            if ([[_filterVideoPlayer.filterList[i] filterClass] isEqualToString:selectedFilterName]) {
                filterIndex = i;
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:filterIndex inSection:0];
    [self collectionView:_filterList didSelectItemAtIndexPath:indexPath];
}

#pragma mark - AFBlipFilterVideoPlayerDelegate methods

- (NSURL *)filterVideoPlayerOutputFilePath:(AFBlipFilterVideoPlayer *)filterVideoPlayer {
    return [_delegate filterViewFilterVideoFilePath:self];
}

- (NSURL *)videoPlayerOutputFilePath:(AFBlipFilterVideoPlayer *)filterVideoPlayer{
    return [_delegate filterViewCaptureVideoFilePath:self];
}

- (NSURL *)filterVideoPlayerThumbnailOutputFilePath:(AFBlipFilterVideoPlayer *)filterVideoPlayer {
    return [_delegate filterViewFilterVideoThumbnailFilePath:self];
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedFilterIndex inSection:0] animated:YES];
    _selectedFilterIndex = indexPath.row;
    if([[(AFBlipFilterVideoModel *)_filterVideoPlayer.filterList[_selectedFilterIndex] filterClass] isEqualToString:@""]) {
        if ([_delegate respondsToSelector:@selector(filterViewOpensFilterPurchaseView:filterView:)]) {
            [_delegate filterViewOpensFilterPurchaseView:^(BOOL success) {
                [_filterVideoPlayer refreshFilterList];
                [_filterList reloadData];
                [_filterVideoPlayer applyFilterForFilterIndex:indexPath.row];
                [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            } filterView:self];
        }
    } else {
      [_filterVideoPlayer applyFilterForFilterIndex:indexPath.row];
    }
    
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSTimeInterval duration;
    CGRect frame = _currentCellMarker.frame;
    
    if(scrollView.isDecelerating || scrollView.isDragging) {
        
        duration       = kAFBlipFilterList_CellMarkerAnimateOutDuration;
        frame.origin.y = CGRectGetHeight(self.bounds) + kAFBlipFilterList_CellMarkerTopOffset;

    } else {
        
        duration = kAFBlipFilterList_CellMarkerAnimateInDuration;
        frame.origin.y = CGRectGetHeight(self.bounds) + kAFBlipFilterList_CellMarkerTopOffset - kAFBlipFilterList_CellMarkerHeight;
    }
    
    if(!CGRectEqualToRect(_currentCellMarker.frame, frame)) {
        [UIView animateWithDuration:duration animations:^{
            
            _currentCellMarker.frame = frame;
        }];
    }
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
    
    CGFloat posX = _filterList.center.x + _filterList.contentOffset.x;
    CGFloat posY = 0;
    NSIndexPath *cellIndexPath = [_filterList indexPathForItemAtPoint:CGPointMake(posX, posY)];
    
    if(cellIndexPath) {
        [_filterList scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    [UIView animateWithDuration:kAFBlipFilterList_CellMarkerAnimateInDuration animations:^{
        
        CGRect frame = _currentCellMarker.frame;
        frame.origin.y = CGRectGetHeight(self.bounds) + kAFBlipFilterList_CellMarkerTopOffset - kAFBlipFilterList_CellMarkerHeight;
        _currentCellMarker.frame = frame;
    }];
}

- (void)dealloc {
    _delegate = nil;
    _filterList.delegate = nil;
    _filterList.dataSource = nil;
}

@end