//
//  AFBlipTimelineDataSource.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAlertView.h"
#import "AFBlipKeychain.h"
#import "AFBlipTimelineDataSource.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipVideoTimelineModel.h"

@implementation AFBlipTimelineDataSource

#pragma mark - Init
- (instancetype)init {
    
    self = [super init];
    if(self) {
        _videoTimelineModel = nil;
    }
    return self;
}

#pragma mark - AFBlipTimelineDataSource
- (void)timeline:(AFBlipTimeline *)timeline pageIndex:(NSUInteger)pageIndex willLoadAppendedData:(AFBlipTimelineAppendedData)appendedData {
 
    switch(_videoTimelineModel.type) {
        case AFBlipVideoTimelineModelType_Favourites:
            [self loadFavouriteListWithPageIndex:pageIndex completion:appendedData];
            break;
        case AFBlipVideoTimelineModelType_All_Recent:
            [self loadAllListWithPageIndex:pageIndex completion:appendedData];
            break;
        case AFBlipVideoTimelineModelType_Recent:
            [self loadRecentListWithPageIndex:pageIndex completion:appendedData];
            break;
        case AFBlipVideoTimelineModelType_None:
        default:
            break;
    }
}

#pragma mark - Favourited list
- (void)loadFavouriteListWithPageIndex:(NSUInteger)pageIndex completion:(AFBlipTimelineAppendedData)completion {
    
    typeof(self) __weak weakSelf = self;
    typeof(_videoTimelineModel) __weak weakVideoTimelineModel = _videoTimelineModel;
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    [factory favouriteVideosAtPageIndex:pageIndex userId:[AFBlipTimelineDataSource userId] accessToken:[AFBlipTimelineDataSource accessToken] success:^(AFBlipVideoTimelineModel *videoTimelineModel, AFBlipBaseNetworkModel *networkCallback) {
        
        weakVideoTimelineModel.totalNumberOfVideos                      = videoTimelineModel.totalNumberOfVideos;
        weakVideoTimelineModel.totalNumberOfPages                       = videoTimelineModel.totalNumberOfPages;
        weakVideoTimelineModel.videos                                   = videoTimelineModel.videos;
        weakVideoTimelineModel.timelineFriendImageURLString             = videoTimelineModel.timelineFriendImageURLString;
        completion(weakVideoTimelineModel.videos);
        
    } failure:^(NSError *error) {
        
        completion(nil);
        
        NSString *message = NSLocalizedString(@"AFBlipTimelineErrorNoVideosFound", nil);
        [weakSelf showAlertViewWithMessage:message];
    }];
}

#pragma mark - All
- (void)loadAllListWithPageIndex:(NSUInteger)pageIndex completion:(AFBlipTimelineAppendedData)completion {
    
    typeof(self) __weak weakSelf                              = self;
    typeof(_videoTimelineModel) __weak weakVideoTimelineModel = _videoTimelineModel;
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    [factory videosAtPageIndex:pageIndex userId:[AFBlipTimelineDataSource userId] accessToken:[AFBlipTimelineDataSource accessToken] timelineIds:_videoTimelineModel.timelineIds singleUserConnectionOnly:NO success:^(AFBlipVideoTimelineModel *videoTimelineModel, AFBlipBaseNetworkModel *networkCallback) {
        
        weakVideoTimelineModel.totalNumberOfVideos                      = videoTimelineModel.totalNumberOfVideos;
        weakVideoTimelineModel.totalNumberOfPages                       = videoTimelineModel.totalNumberOfPages;
        weakVideoTimelineModel.videos                                   = videoTimelineModel.videos;
        weakVideoTimelineModel.timelineFriendImageURLString             = videoTimelineModel.timelineFriendImageURLString;
        completion(weakVideoTimelineModel.videos);
        
    } failure:^(NSError *error) {
        
        completion(nil);
        
        NSString *message = NSLocalizedString(@"AFBlipTimelineErrorNoVideosFound", nil);
        [weakSelf showAlertViewWithMessage:message];
    }];
}

#pragma mark - Recent
- (void)loadRecentListWithPageIndex:(NSUInteger)pageIndex completion:(AFBlipTimelineAppendedData)completion {
    
    typeof(self) __weak weakSelf                              = self;
    typeof(_videoTimelineModel) __weak weakVideoTimelineModel = _videoTimelineModel;
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    [factory videosAtPageIndex:pageIndex userId:[AFBlipTimelineDataSource userId] accessToken:[AFBlipTimelineDataSource accessToken] timelineIds:_videoTimelineModel.timelineIds singleUserConnectionOnly:YES success:^(AFBlipVideoTimelineModel *videoTimelineModel, AFBlipBaseNetworkModel *networkCallback) {
        
        weakVideoTimelineModel.totalNumberOfVideos                      = videoTimelineModel.totalNumberOfVideos;
        weakVideoTimelineModel.totalNumberOfPages                       = videoTimelineModel.totalNumberOfPages;
        weakVideoTimelineModel.videos                                   = videoTimelineModel.videos;
        weakVideoTimelineModel.timelineFriendImageURLString             = videoTimelineModel.timelineFriendImageURLString;
        completion(weakVideoTimelineModel.videos);
        
    } failure:^(NSError *error) {
        
        completion(nil);
        
        NSString *message = NSLocalizedString(@"AFBlipTimelineErrorNoVideosFound", nil);
        [weakSelf showAlertViewWithMessage:message];
    }];
}

- (NSUInteger)timelineTotalNumberOfPages {
    
    return _videoTimelineModel.totalNumberOfPages;
}

#pragma mark - Alert view
- (void)showAlertViewWithMessage:(NSString *)message {
    
    NSString *title = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
    NSString *dismiss = NSLocalizedString(@"AFBlipSigninForFailureButtonTitle", nil);
    AFBlipAlertView *alertView = [[AFBlipAlertView alloc] initWithTitle:title message:message buttonTitles:@[dismiss]];
    [alertView show];
}

#pragma mark - Set new timeline model
- (void)setVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel {
    
    _videoTimelineModel = videoTimelineModel;
}

#pragma mark - User id
+ (NSString *)userId {
    
    return [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
}

#pragma mark - Access token
+ (NSString *)accessToken {
    
    return [AFBlipKeychain keychain].accessToken;
}

@end