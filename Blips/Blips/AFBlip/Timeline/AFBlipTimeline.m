//
//  AFBlipTimeline.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/10/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipAlertView.h"
#import "AFBlipKeychain.h"
#import "AFBlipTimeline.h"
#import "AFBlipTimelineCanvas.h"
#import "AFBlipTimelineDataSource.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModelFactory.h"
#import "AFFAlertViewButtonModel.h"

const CGFloat kAFBlipTimeline_VeticalContentInset = 60.0f;

@interface AFBlipTimeline () <AFBlipTimelineCanvasDelegate, AFFAlertViewDelegate> {
    
    NSUInteger                  _currentPageIndex;
    BOOL                        _isLoadingData;
    AFBlipTimelineCanvas        *_timelineCanvas;
    AFBlipTimelineDataSource    *_timelineDataSource;
}

@end

@implementation AFBlipTimeline

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    return [self init];
}

- (instancetype)init {
    
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        
        _currentPageIndex = 0;
        _isLoadingData   = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    [self createTimelineCanvas];
    [self createDataSource];
}

#pragma mark - Create timeline
- (void)createTimelineCanvas {
    
    CGRect frame      = self.view.frame;
    frame.size.height = CGRectGetHeight(frame) - kAFBlipTimeline_VeticalContentInset;
    
    _timelineCanvas                  = [[AFBlipTimelineCanvas alloc] initWithFrame:frame];
    _timelineCanvas.delegate         = self;
    self.view                        = _timelineCanvas;
}

#pragma mark - Create data source
- (void)createDataSource {
    
    _timelineDataSource = [[AFBlipTimelineDataSource alloc] init];
}

#pragma mark - AFBlipTimelineCanvasDelegate
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectNewVideoWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {
    
    [_delegate timelineCanvas:self didSelectNewVideoWithVideoTimelineModel:videoTimelineModel];
}

- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectDeleteFriend:(NSString *)friendUserId friendDisplayName:(NSString *)friendDisplayName {
    
    NSString *title    = NSLocalizedString(@"AFBlipRemoveFriendModalTitle", nil);
    NSString *message  = [NSString stringWithFormat:NSLocalizedString(@"AFBlipRemoveFriendModalMessage", nil), friendDisplayName];
    NSString *noTitle  = NSLocalizedString(@"AFBlipRemoveFriendModalNo", nil);
    NSString *yesTitle = NSLocalizedString(@"AFBlipRemoveFriendModalYes", nil);
    
    AFBlipAlertView *deleteUserModal = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[noTitle, yesTitle]];
    deleteUserModal.delegate = self;
    [deleteUserModal show];
}

- (void)timelineCanvasDidSelectRefresh:(AFBlipTimelineCanvas *)timeline {
    
    [self reloadData];
}

- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectConnectionProfile:(AFBlipVideoModel *)videoModel {
    
    [_delegate timelineCanvas:self didSelectConnectionProfile:videoModel];
}

- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectVideo:(AFBlipVideoModel *)videoModel videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {
    
    [_delegate timelineCanvas:self didSelectVideo:videoModel videoTimelineModel:videoTimelineModel];
}

- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectFavouriteVideo:(AFBlipVideoModel *)videoModel {
 
    [self setFavourite:YES videoModel:videoModel];
}

- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectUnfavouriteVideo:(AFBlipVideoModel *)videoModel {
    
    [self setFavourite:NO videoModel:videoModel];
}

- (void)setFavourite:(BOOL)favourite videoModel:(AFBlipVideoModel *)videoModel {
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    NSString *accessToken            = [AFBlipKeychain keychain].accessToken;
    NSString *userId                 = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *videoId                = videoModel.videoId;
    
    if(favourite) {
        
        NSString *timelineId  = videoModel.timelineId;
        NSInteger favouriteDate = ((long)[[NSDate date] timeIntervalSince1970]);

        [factory setFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoId favouritedDate:favouriteDate timelineId:timelineId success:^(AFBlipBaseNetworkModel *networkCallback) {
            
            if(networkCallback.success) {
                videoModel.favourited = YES;
            } else {
                videoModel.favourited = NO;
            }
        } failure:^(NSError *error) {
            videoModel.favourited = NO;
        }];
    } else {
        
        [factory removeFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoId success:^(AFBlipBaseNetworkModel *networkCallback) {

            if(networkCallback.success) {
                videoModel.favourited = NO;
            } else {
                videoModel.favourited = YES;
            }
        } failure:^(NSError *error) {
            videoModel.favourited = YES;
        }];
    }
}

- (BOOL)timelineCanvasShouldDeleteRowWhenUnfavourited:(AFBlipTimelineCanvas *)timeline {
    
    //Favourites timelist requires the removal of the favourited cell
    return _timelineDataSource.videoTimelineModel.type == AFBlipVideoTimelineModelType_Favourites;
}

- (void)timelineCanvasWillReachEnd:(AFBlipTimelineCanvas *)timeline {
    
    if([_delegate respondsToSelector:@selector(timelineWillReadEnd:)]) {
        
        [_delegate timelineWillReadEnd:self];
    }
    
    //Check if more data can be loaded
    if(![self canLoadAppendedData]) {
        return;
    }
    
    _isLoadingData = YES;
    
    [_timelineDataSource timeline:self pageIndex:_currentPageIndex willLoadAppendedData:^(NSArray *data) {
        
        if(data) {
            
            [_timelineCanvas appendData:data];
            _currentPageIndex ++;
            _isLoadingData = NO;
        }
    }];
}

- (void)timelineCanvasDidReachEnd:(AFBlipTimelineCanvas *)timeline {
    
    if([_delegate respondsToSelector:@selector(timelineDidReadEnd:)]) {
        
        [_delegate timelineDidReadEnd:self];
    }
    
    //Check if more data can be loaded
    if(![self canLoadAppendedData]) {
        return;
    }
    
    _isLoadingData = YES;
    
    [_timelineDataSource timeline:self pageIndex:_currentPageIndex willLoadAppendedData:^(NSArray *data) {
        
        if(data) {
            
            [_timelineCanvas appendData:data];
            _currentPageIndex ++;
            _isLoadingData = NO;
        }
    }];
}

- (BOOL)canLoadAppendedData {
    
    return !_isLoadingData && _currentPageIndex < [_timelineDataSource timelineTotalNumberOfPages];
}

#pragma mark - AFFAlertViewDelegate
- (void)alertView:(AFFAlertView *)alertView didDismissWithButton:(AFFAlertViewButtonModel *)buttonModel {
    
    //Yes
    if(buttonModel.index == 1) {
        
        [_timelineCanvas showActivityIndicator:YES animatedHeader:NO];
        
        typeof(self) __weak weakSelf = self;
        typeof(_delegate) __weak weakDelegate = _delegate;
        typeof(_timelineCanvas) __weak weakTimelineCanvas = _timelineCanvas;

        NSString *userId                 = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
        NSString *accessToken            = [AFBlipKeychain keychain].accessToken;
        NSString *connectionId           = _timelineDataSource.videoTimelineModel.timelineConnectionId;
        
        AFBlipUserModelFactory *factory = [[AFBlipUserModelFactory alloc] init];
        [factory removeFriendWithUserId:userId connectionId:connectionId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
            
            [weakDelegate timelineCanvasDidRemoveFriend:self];
            
        } failure:^(NSError *error) {
            [weakSelf displayRemoveFriendAlertViewFailure];
            [weakTimelineCanvas showActivityIndicator:NO animatedHeader:NO];
        }];
    }
}

- (void)displayRemoveFriendAlertViewFailure {
    
    NSString *title        = NSLocalizedString(@"AFBlipSigninForFailureTitle", nil);
    NSString *message      = NSLocalizedString(@"AFBlipRemoveFriendModalMessageFailure", nil);
    NSString *dismissTitle = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
    
    AFBlipAlertView *deleteUserFailureModal = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismissTitle]];
    [deleteUserFailureModal show];
}

#pragma mark - Set new data
- (void)setNewTimelineModel:(AFBlipVideoTimelineModel *)timelineModel {
    
    //Load timeline
    _timelineDataSource.videoTimelineModel = timelineModel;
    [self reloadData];
}

#pragma mark - Delete
- (void)deleteVideoModel:(AFBlipVideoModel *)model {

    NSMutableArray *videos = [_timelineDataSource.videoTimelineModel.videos mutableCopy];
    [videos removeObject:model];
    _timelineDataSource.videoTimelineModel.videos = videos;
    
    [_timelineCanvas deleteVideoModel:model];
}

#pragma mark - Reload
- (void)reloadData {
    
    //Show activity indicator
    [_timelineCanvas showActivityIndicator:YES];
    
    AFBlipUserModel __weak *userModel                 = [AFBlipUserModelSingleton sharedUserModel].userModel;
    AFBlipVideoTimelineModel __block *timelineModel   = _timelineDataSource.videoTimelineModel;
    typeof(_timelineCanvas) __weak weakTimelineCanvas = _timelineCanvas;
    
    _currentPageIndex = 0;
    [_timelineDataSource timeline:self pageIndex:_currentPageIndex willLoadAppendedData:^(NSArray *data) {
        
        [weakTimelineCanvas setData:data userModel:userModel timelineModel:timelineModel];
        _currentPageIndex = 1;
        
    }];
}

- (void)reloadTimelineCellWithModel:(AFBlipVideoModel *)model {
    [_timelineCanvas reloadCellWithModel:model];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate           = nil;
    _timelineDataSource = nil;
}

@end
