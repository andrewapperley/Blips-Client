//
//  AFBlipLimitedProfileViewContentView.h
//  Blips
//
//  Created by Andrew Apperley on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpBaseView.h"

@class AFBlipLimitedProfileModel;

@interface AFBlipLimitedProfileViewContentView : AFBlipInitialViewControllerSignInUpBaseView

- (id)initWithFrame:(CGRect)frame model:(AFBlipLimitedProfileModel *)model toAdd:(BOOL)toAdd;

@end