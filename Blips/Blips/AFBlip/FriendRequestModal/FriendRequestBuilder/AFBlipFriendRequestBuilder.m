//
//  AFBlipFriendRequestBuilder.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-04.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionModelFactory.h"
#import "AFBlipFriendRequestBuilder.h"
#import "AFBlipFriendRequestModal.h"
#import "AFBlipKeychain.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipNotificationsModelFactory.h"

@interface AFBlipFriendRequestBuilder () <AFBlipFriendRequestModalDelegate>

@end

@implementation AFBlipFriendRequestBuilder

#pragma mark - Display
- (void)displayRequestType:(AFBlipFriendRequestModalType)type data:(NSDictionary *)data {
    
    if(!data) {
        return;
    }

    NSString *accessToken          = [AFBlipKeychain keychain].accessToken;

    if(!accessToken) {
        return;
    }
    
    switch(type) {
        case AFBlipFriendRequestModalType_FriendRequest:
            [self displayFriendRequestWithData:data accessToken:accessToken];
            break;
        case AFBlipFriendRequestModalType_FriendRequestConfirmation:
            [self displayFriendRequestConfirmationWithData:data accessToken:accessToken];
            break;
        case AFBlipFriendRequestModalType_NewVideo:
            [self displayNewVideoWithData:data accessToken:accessToken];
            break;
        default:
            break;
    }
}
                            
#pragma mark - Friend request
- (void)displayFriendRequestWithData:(NSDictionary *)data accessToken:(NSString *)accessToken {
    
    NSString *userId               = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *friendUserId         = data[@"user_id"];
    NSString __block *connectionId = data[@"connection_id"];
    
    if(!userId || !connectionId) {
        return;
    }
    
    AFBlipUserModelFactory *factory = [[AFBlipUserModelFactory alloc] init];
    [factory fetchUserModelWithUserId:userId friendUserId:friendUserId  accessToken:accessToken success:^(AFBlipUserModel *userModel, AFBlipBaseNetworkModel *networkCallback) {
        
        //Modal
        [self displayModal:AFBlipFriendRequestModalType_FriendRequest displayName:userModel.displayName imageURLString:userModel.userImageUrl data:data];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Friend request confirmation
- (void)displayFriendRequestConfirmationWithData:(NSDictionary *)data accessToken:(NSString *)accessToken {
    
    NSString *userId               = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *friendUserId         = data[@"user_id"];
    NSString __block *timelineId   = data[@"timeline_id"];
    
    if(!userId || !timelineId) {
        return;
    }
    
    AFBlipUserModelFactory *factory = [[AFBlipUserModelFactory alloc] init];
    [factory fetchUserModelWithUserId:userId friendUserId:friendUserId accessToken:accessToken success:^(AFBlipUserModel *userModel, AFBlipBaseNetworkModel *networkCallback) {
        
        //Modal
        [self displayModal:AFBlipFriendRequestModalType_FriendRequestConfirmation displayName:userModel.displayName imageURLString:userModel.userImageUrl data:@{@"timelineId": timelineId, @"friend": userModel}];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - New video
- (void)displayNewVideoWithData:(NSDictionary *)data accessToken:(NSString *)accessToken {
    
    NSString *userId             = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString __block *timelineId = data[@"timeline_id"];


    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    [factory videosAtPageIndex:0 userId:userId accessToken:accessToken timelineIds:@[timelineId] singleUserConnectionOnly:YES success:^(AFBlipVideoTimelineModel *videoTimelineModel, AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            //Video image URL
            AFBlipVideoModel *videoModel = [videoTimelineModel.videos firstObject];
            
            //If no video models then return
            if(!videoModel) {
                return;
            }
            
            NSString *displayName         = videoModel.userName;
            NSString *videoImageURLString = videoModel.thumbnailURLString;

            videoTimelineModel.videos     = @[videoModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Modal
                [self displayModal:AFBlipFriendRequestModalType_NewVideo displayName:displayName imageURLString:videoImageURLString data:videoTimelineModel];
            });
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)displayModal:(AFBlipFriendRequestModalType)type displayName:(NSString *)displayName imageURLString:(NSString *)imageURLString data:(id)data {
    
    AFBlipFriendRequestModal *modal  = [[AFBlipFriendRequestModal alloc] initWithType:type displayName:displayName imageURLString:imageURLString data:data];
    modal.friendRequestModalDelegate = self;
    [modal show];
}

#pragma mark - AFBlipFriendRequestModalDelegate
- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didAcceptFriendInvitation:(BOOL)didAcceptFriendInvitation {

    NSString *accessToken   = [AFBlipKeychain keychain].accessToken;
    NSString *userId        = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSDictionary *data      = friendRequestModal.data;
    
    NSString *friendUserId  = data[@"user_id"];
    NSString *connectionId  = data[@"connection_id"];
    
    AFBlipConnectionModelFactory *factory = [[AFBlipConnectionModelFactory alloc] init];
    [factory changeConnectionStatusWithUserID:userId connectionID:connectionId status:didAcceptFriendInvitation accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        AFBlipNotificationsModelFactory *factory = [[AFBlipNotificationsModelFactory alloc] init];
        [factory markNotificationAsReadForNotificationUserId:friendUserId userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
            [_delegate friendRequestBuilder:self didAcceptFriendInvitation:didAcceptFriendInvitation];
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {

    }];
}

- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didSelectPostVideo:(BOOL)didSelectPostVideo {
    
    if(!didSelectPostVideo) {
        return;
    }
    
    AFBlipUserModel *friendUser = friendRequestModal.data[@"friend"];
    NSString *timelineId   = friendRequestModal.data[@"timelineId"];
        
    [_delegate friendRequestBuilder:self didSelectCreateVideoWithUser:friendUser timelineId:timelineId];
}

- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didSelectViewVideo:(BOOL)didViewVideo {
    
    if(!didViewVideo) {
        return;
    }
    
    [_delegate friendRequestBuilder:self didSelectViewVideoWithTimelineModel:friendRequestModal.data];
}

#pragma mark - Dealloc
- (void)dealloc {
    _delegate = nil;
}

@end