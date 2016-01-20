//
//  AFBlipTimelineCanvasCell.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipVideoModel;
@class AFBlipTimelineCanvasCell;

@protocol AFBlipTimelineCanvasCellDelegate <NSObject>

@required
- (void)timelineCanvasCellDidPressVideo:(AFBlipTimelineCanvasCell *)cell;
- (void)timelineCanvasCellDidPressProfile:(AFBlipTimelineCanvasCell *)cell;
- (void)timelineCanvasCellDidFavouriteVideo:(AFBlipTimelineCanvasCell *)cell;
- (void)timelineCanvasCellDidUnfavouriteVideo:(AFBlipTimelineCanvasCell *)cell;

@end

@interface AFBlipTimelineCanvasCell : UICollectionViewCell

@property (nonatomic, weak) id<AFBlipTimelineCanvasCellDelegate> delegate;

#pragma mark - Data
/** Sets the data for the cell. */
- (void)setVideoModel:(AFBlipVideoModel *)videoModel;

#pragma mark - Position
/** Sets the position relative to it's visible container. */
- (void)setParallaxPosition:(CGFloat)position;

#pragma mark - Cell height
+ (CGFloat)cellHeight;

@end
