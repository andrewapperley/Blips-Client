//
//  AFBlipInitialViewControllerSignInView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInView.h"
#import "AFBlipInitialViewControllerSignInViewContentView.h"

#pragma mark - Constants
const CGFloat kAFBlipInitialViewControllerSignInView_DragViewHeight = 300.0f;

@implementation AFBlipInitialViewControllerSignInView

- (instancetype)initWithFrame:(CGRect)frame blockerImage:(UIImage *)blockerImage {
    
    self = [super initWithFrame:frame draggableView:[AFBlipInitialViewControllerSignInView draggableView:frame] blockerImage:blockerImage];
    if(self) {
        
    }
    
    return self;
}

+ (AFBlipInitialViewControllerSignInViewContentView *)draggableView:(CGRect)frame {
    
    AFBlipInitialViewControllerSignInViewContentView *draggableView = [[AFBlipInitialViewControllerSignInViewContentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), kAFBlipInitialViewControllerSignInView_DragViewHeight)];
    
    return draggableView;
}

@end