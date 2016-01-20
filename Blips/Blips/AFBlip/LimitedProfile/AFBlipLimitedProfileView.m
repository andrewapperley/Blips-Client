//
//  AFBlipLimitedProfileView.m
//  Blips
//
//  Created by Andrew Apperley on 2014-04-07.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipLimitedProfileView.h"
#import "AFBlipLimitedProfileViewContentView.h"

const CGFloat kAFBlipLimitedProfileView_DragViewHeight      = 280.0f;
const CGFloat kAFBlipLimitedProfileViewNoAdd_DragViewHeight = 240.0f;

@implementation AFBlipLimitedProfileView

- (instancetype)initWithFrame:(CGRect)frame  blockerImage:(UIImage *)blockerImage model:(AFBlipLimitedProfileModel *)model toAdd:(BOOL)toAdd {
    
    self = [super initWithFrame:frame draggableView:[AFBlipLimitedProfileView draggableView:frame model:model toAdd:toAdd] blockerImage:blockerImage];
    if(self) {
        
    }
    
    return self;
}

+ (AFBlipLimitedProfileViewContentView *)draggableView:(CGRect)frame model:(AFBlipLimitedProfileModel *)model toAdd:(BOOL)toAdd {
    
    AFBlipLimitedProfileViewContentView *draggableView = [[AFBlipLimitedProfileViewContentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), (toAdd) ? kAFBlipLimitedProfileView_DragViewHeight : kAFBlipLimitedProfileViewNoAdd_DragViewHeight) model:model toAdd:toAdd];
    
    return draggableView;
}

@end