//
//  AFBlipShareViewControllerView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipVideoTimelineModel;

@interface AFBlipShareViewControllerView : UIView

@property (nonatomic, readonly) NSString *message;

- (instancetype)initWithFrame:(CGRect)frame videoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel message:(NSString *)message;

@end