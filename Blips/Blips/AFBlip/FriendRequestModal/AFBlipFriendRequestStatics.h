//
//  AFBlipFriendRequestStatics.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-04.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

typedef NS_ENUM(NSUInteger, AFBlipFriendRequestModalType) {
    
    /** Presents a modal representing a friend request. */
    AFBlipFriendRequestModalType_FriendRequest              = 0,
    
    /** Presents a modal representing a friend request acceptance notification. */
    AFBlipFriendRequestModalType_FriendRequestConfirmation  = 1,
    
    /** Presents a modal representing a new video notification. */
    AFBlipFriendRequestModalType_NewVideo                   = 2
};