//
//  AFBlipLimitedProfileView.h
//  Blips
//
//  Created by Andrew Apperley on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerBaseDragView.h"

@class AFBlipLimitedProfileModel;

@interface AFBlipLimitedProfileView : AFBlipInitialViewControllerBaseDragView

- (instancetype)initWithFrame:(CGRect)frame blockerImage:(UIImage *)blockerImage model:(AFBlipLimitedProfileModel *)model toAdd:(BOOL)toAdd;

@end