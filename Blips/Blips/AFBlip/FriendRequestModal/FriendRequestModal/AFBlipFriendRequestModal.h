//
//  AFBlipFriendRequestModal.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAlertView.h"
#import "AFBlipFriendRequestStatics.h"

@class AFBlipFriendRequestModal;

@protocol AFBlipFriendRequestModalDelegate <NSObject>

@optional
/** Friend request callback response. */
- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didAcceptFriendInvitation:(BOOL)didAcceptFriendInvitation;

/** Friend confirmation callback response. */
- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didSelectPostVideo:(BOOL)didSelectPostVideo;

/** New video callback response. */
- (void)friendRequestModal:(AFBlipFriendRequestModal *)friendRequestModal didSelectViewVideo:(BOOL)didViewVideo;

@end

@interface AFBlipFriendRequestModal : AFBlipAlertView

@property (nonatomic, strong) id<AFBlipFriendRequestModalDelegate> friendRequestModalDelegate;
@property (nonatomic, strong, readonly) id data;

- (instancetype)initWithType:(AFBlipFriendRequestModalType)type displayName:(NSString *)displayName imageURLString:(NSString *)imageURLString data:(id)data;

@end