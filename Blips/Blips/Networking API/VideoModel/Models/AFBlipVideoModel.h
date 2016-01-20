//
//  AFBlipVideoModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipVideoModel : NSObject

@property (nonatomic) NSInteger date;
@property (nonatomic, strong, readonly) NSString *thumbnailURLString;
@property (nonatomic, strong, readonly) NSString *videoId;
@property (nonatomic, strong, readonly) NSString *videoURL;
@property (nonatomic, strong, readonly) NSString *timelineId;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *userThumbnailURLString;
@property (nonatomic, strong, readonly) NSString *videoDescription;
@property (nonatomic, assign) BOOL favourited;
@property (nonatomic, assign) BOOL flagged;

@end
