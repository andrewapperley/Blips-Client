//
//  AFBlipFriendRequestBuilder.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-04.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipFriendRequestStatics.h"

@class AFBlipFriendRequestBuilder;
@class AFBlipUserModel;
@class AFBlipVideoTimelineModel;

@protocol AFBlipFriendRequestBuilderDelegate <NSObject>

@required
- (void)friendRequestBuilder:(AFBlipFriendRequestBuilder *)friendRequestBuilder didAcceptFriendInvitation:(BOOL)didAcceptFriendInvitation;
- (void)friendRequestBuilder:(AFBlipFriendRequestBuilder *)friendRequestBuilder didSelectCreateVideoWithUser:(AFBlipUserModel *)friendModel timelineId:(NSString *)timelindId;
- (void)friendRequestBuilder:(AFBlipFriendRequestBuilder *)friendRequestBuilder didSelectViewVideoWithTimelineModel:(AFBlipVideoTimelineModel *)timelineModel;

@end

@interface AFBlipFriendRequestBuilder : NSObject

@property (nonatomic, weak) id<AFBlipFriendRequestBuilderDelegate> delegate;

/** Attempts to display a AFBlipFriendRequestModal view with the given data string. */
- (void)displayRequestType:(AFBlipFriendRequestModalType)type data:(NSDictionary *)data;

@end