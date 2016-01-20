//
//  AFBlipVideoTimelineModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AFBlipVideoTimelineModelType) {
    
    /** Loads nothing. */
    AFBlipVideoTimelineModelType_None,
    
    /** Loads recent blips for another connection. */
    AFBlipVideoTimelineModelType_Recent,
    
    /** Loads all recent blips from all connections. */
    AFBlipVideoTimelineModelType_All_Recent,
    
    /** Loads all favourite blips. */
    AFBlipVideoTimelineModelType_Favourites
};

@interface AFBlipVideoTimelineModel : NSObject

@property (nonatomic, assign) AFBlipVideoTimelineModelType type;
@property (nonatomic, assign) NSUInteger totalNumberOfPages;
@property (nonatomic, assign) NSUInteger totalNumberOfVideos;
@property (nonatomic, copy) NSArray *timelineIds;
@property (nonatomic, copy) NSString *timelineConnectionId;
@property (nonatomic, copy) NSString *timelineUserId;
@property (nonatomic, copy) NSString *timelineTitle;
@property (nonatomic, copy) NSString *timelineDescription;
@property (nonatomic, copy) NSString *timelineFriendImageURLString;
@property (nonatomic, copy) NSArray *videos;        //Contains AFBlipVideoModel's

@end
