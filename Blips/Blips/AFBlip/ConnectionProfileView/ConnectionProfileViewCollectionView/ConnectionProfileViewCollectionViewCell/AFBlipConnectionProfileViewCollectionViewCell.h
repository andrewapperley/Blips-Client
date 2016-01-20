//
//  AFBlipConnectionProfileViewCollectionViewCell.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipVideoTimelineModel;

@interface AFBlipConnectionProfileViewCollectionViewCell : UICollectionViewCell

- (void)updateWithTimelineModel:(AFBlipVideoTimelineModel *)timelineModel;

@end