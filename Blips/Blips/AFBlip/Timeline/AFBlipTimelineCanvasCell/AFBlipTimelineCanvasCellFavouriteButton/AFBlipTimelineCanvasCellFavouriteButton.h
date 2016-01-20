//
//  AFBlipTimelineCanvasCellFavouriteButton.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-21.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFBlipTimelineCanvasCellFavouriteButton : UIButton

@property (nonatomic, assign, readonly) BOOL favourited;

- (void)setFavourited:(BOOL)favourited animated:(BOOL)animated;

+ (CGSize)preferredSize;

@end