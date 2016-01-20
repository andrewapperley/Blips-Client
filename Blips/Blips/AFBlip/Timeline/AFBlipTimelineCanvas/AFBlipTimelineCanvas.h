//
//  AFBlipTimelineCanvas.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipTimelineCanvas;
@class AFBlipUserModel;
@class AFBlipVideoModel;
@class AFBlipVideoTimelineModel;

@protocol AFBlipTimelineCanvasDelegate <NSObject>

@required
/** Called when the timeline will reach the end of it's current available data when scrolling. */
- (void)timelineCanvasWillReachEnd:(AFBlipTimelineCanvas *)timeline;

/** Called when the timeline did reach the end of it's current available data when scrolling. */
- (void)timelineCanvasDidReachEnd:(AFBlipTimelineCanvas *)timeline;

/** Called when the timeline was selected to create a new video. */
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectNewVideoWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel;

/** Called when the timeline was selected to delete a user. */
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectDeleteFriend:(NSString *)friendUserId friendDisplayName:(NSString *)friendDisplayName;

/** Called when the timeline was selected to view a connection profile. */
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectConnectionProfile:(AFBlipVideoModel *)videoModel;

/** Called when the refresh indicator is activated. */
- (void)timelineCanvasDidSelectRefresh:(AFBlipTimelineCanvas *)timeline;

/** Called when the timeline was selected to view a video. */
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectVideo:(AFBlipVideoModel *)videoModel videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel;

/** Called when the timeline was selected to favourite a video. */
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectFavouriteVideo:(AFBlipVideoModel *)videoModel;

/** Called when the timeline was selected to unfavourite a video. */
- (void)timelineCanvas:(AFBlipTimelineCanvas *)timeline didSelectUnfavouriteVideo:(AFBlipVideoModel *)videoModel;

/** Called when the timeline was selected to unfavourite a video. */
- (BOOL)timelineCanvasShouldDeleteRowWhenUnfavourited:(AFBlipTimelineCanvas *)timeline;

@end

@interface AFBlipTimelineCanvas : UIView

@property (nonatomic, weak) id<AFBlipTimelineCanvasDelegate> delegate;

#pragma mark - Data handling
/** Sets to data to the timeline canvas. */
- (void)setData:(NSArray *)data userModel:(AFBlipUserModel *)userModel timelineModel:(AFBlipVideoTimelineModel *)timelineModel;

/** Delete video model. */
- (void)deleteVideoModel:(AFBlipVideoModel *)videoModel;

/** Append data to the existing timeline canvas data. This will resize the collection view's content size. */
- (void)appendData:(NSArray *)data;

/** Reloads cell using Video Model */
- (void)reloadCellWithModel:(AFBlipVideoModel *)model;

#pragma mark - Activity indicator
/** Show an activity indicator with an animated header. */
- (void)showActivityIndicator:(BOOL)show;

/** Show an activity indicator with an optional animated header. */
- (void)showActivityIndicator:(BOOL)show animatedHeader:(BOOL)animatedHeader;

@end