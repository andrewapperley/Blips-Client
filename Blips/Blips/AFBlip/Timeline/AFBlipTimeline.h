//
//  AFBlipTimeline.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/10/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipTimeline;
@class AFBlipVideoModel;
@class AFBlipVideoTimelineModel;

typedef void(^AFBlipTimelineAppendedData)(NSArray *data);

@protocol AFBlipTimelineDelegate <NSObject>

#pragma mark - Presses
@required
/** Called when the timeline was selected to create a new video. */
- (void)timelineCanvas:(AFBlipTimeline *)timeline didSelectNewVideoWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel;

/** Called when the timeline was selected to view a connection profile. */
- (void)timelineCanvas:(AFBlipTimeline *)timeline didSelectConnectionProfile:(AFBlipVideoModel *)videoModel;

/** Called when the timeline was selected to view a video. */
- (void)timelineCanvas:(AFBlipTimeline *)timeline didSelectVideo:(AFBlipVideoModel *)videoModel videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel;

/** Called when a friend is deleted from the current timeline. */
- (void)timelineCanvasDidRemoveFriend:(AFBlipTimeline *)timeline;

#pragma mark - Scrolling
@optional
/** Sent when the canvas position will scroll to the end of it's content size. */
- (void)timelineWillReadEnd:(AFBlipTimeline *)timeline;

/** Sent when the canvas position did scroll to the end of it's content size. */
- (void)timelineDidReadEnd:(AFBlipTimeline *)timeline;

@end

@protocol AFBlipTimelineDataSource <NSObject>

#pragma mark - Data loading from scrolling
@required
/** Asks the data source for data to be appended to the current timeline canvas. */
- (void)timeline:(AFBlipTimeline *)timeline pageIndex:(NSUInteger)pageIndex willLoadAppendedData:(AFBlipTimelineAppendedData)appendedData;

/** Asks the data source for the total number of pages in the current timeline canvas. */
- (NSUInteger)timelineTotalNumberOfPages;

@end

/** AFBlipTimeline is an view controller class that is used with an AFBlipTimelineCanvas. It handles the data management from it's delegate and data source methods and passes it to the AFBlipTimelineCanvas view. */
@interface AFBlipTimeline : UIViewController

@property (nonatomic, weak) id<AFBlipTimelineDelegate> delegate;

/** Sets a new data model for the timeline. This will also call '- (void)reloadData'. */
- (void)setNewTimelineModel:(AFBlipVideoTimelineModel *)timelineModel;

/** Reloads the video model. */
- (void)deleteVideoModel:(AFBlipVideoModel *)model;

/** Reloads the timeline data. */
- (void)reloadData;

/** Reloads a timeline cell. */
- (void)reloadTimelineCellWithModel:(AFBlipVideoModel *)model;

@end
