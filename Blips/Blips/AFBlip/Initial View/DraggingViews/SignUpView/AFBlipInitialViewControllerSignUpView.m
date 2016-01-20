//
//  AFBlipInitialViewControllerSignUpView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignUpView.h"
#import "AFBlipInitialViewControllerSignUpViewContentView.h"

#pragma mark - Constants
const CGFloat kAFBlipInitialViewControllerSignUpView_DragViewHeight = 400.0f;

@implementation AFBlipInitialViewControllerSignUpView

- (instancetype)initWithFrame:(CGRect)frame blockerImage:(UIImage *)blockerImage {
    
    self = [super initWithFrame:frame draggableView:[AFBlipInitialViewControllerSignUpView draggableView:frame] blockerImage:blockerImage];
    if(self) {
        
    }
    
    return self;
}

+ (AFBlipInitialViewControllerSignUpViewContentView *)draggableView:(CGRect)frame {
    
    AFBlipInitialViewControllerSignUpViewContentView *draggableView = [[AFBlipInitialViewControllerSignUpViewContentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), kAFBlipInitialViewControllerSignUpView_DragViewHeight)];
    
    return draggableView;
}

@end