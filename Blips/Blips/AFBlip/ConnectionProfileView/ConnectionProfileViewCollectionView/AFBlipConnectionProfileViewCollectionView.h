//
//  AFBlipConnectionProfileViewCollectionView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipConnectionProfileViewCollectionView;
@class AFBlipVideoTimelineModel;

@protocol AFBlipConnectionProfileViewCollectionViewDelegate <NSObject>

@required

/** Returns the number of items in the collection view. */
- (NSUInteger)connectionProfileViewCollectionViewNumberOfItems:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView;

/** Returns the data object for a collection view cell. */
- (AFBlipVideoTimelineModel *)connectionProfileViewCollectionView:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView itemAtIndex:(NSUInteger)index;

/** Called when the 'new timeline' cell is selected. */
- (void)connectionProfileViewCollectionViewDidSelectCreateNewTimeline:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView;

/** Called when a timeline cell is selected. */
- (void)connectionProfileViewCollectionView:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView didSelectTimelineModel:(AFBlipVideoTimelineModel *)timelineModel;

@optional
/** Called when the collection view scrolls. */
- (void)connectionProfileViewCollectionViewDidScroll:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView;

@end

@interface AFBlipConnectionProfileViewCollectionView : UICollectionView

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, weak) id<AFBlipConnectionProfileViewCollectionViewDelegate> connectionProfileViewDelegate;

@end