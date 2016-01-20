//
//  AFBlipTimelineHeader.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-04-13.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipTimelineHeader;
@class AFBlipVideoTimelineModel;

@protocol AFBlipTimelineHeaderDelegate <NSObject>

@required
- (void)timelineHeaderDidSelectNewVideo:(AFBlipTimelineHeader *)timelineHeader;
- (void)timelineHeaderDidSelectDelete:(AFBlipTimelineHeader *)timelineHeader;
- (void)timelineHeaderDidSelectRefresh:(AFBlipTimelineHeader *)timelineHeader;

@end

@interface AFBlipTimelineHeader : UIView

@property (nonatomic, weak) id<AFBlipTimelineHeaderDelegate> delegate;

/** Sets timeline model. */
- (void)setTimelineModel:(AFBlipVideoTimelineModel *)timelineModel;

/** Adjusts the header height based on a given position. */
- (void)setHeaderInternalPosY:(CGFloat)internalPosY;

/** Returns the max height. */
- (CGFloat)maxHeaderHeight;

/** Set refreshing. */
- (void)setRefreshing:(BOOL)isRefreshing;

@end