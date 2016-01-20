//
//  AFBlipTimelineDataSource.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTimeline.h"

@class AFBlipVideoTimelineModel;

@interface AFBlipTimelineDataSource : NSObject<AFBlipTimelineDataSource>

@property (nonatomic, strong) AFBlipVideoTimelineModel *videoTimelineModel;

@end
