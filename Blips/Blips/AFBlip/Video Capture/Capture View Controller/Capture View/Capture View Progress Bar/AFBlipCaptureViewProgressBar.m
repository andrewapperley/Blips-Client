//
//  AFBlipCaptureViewProgressBar.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-22.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipCaptureViewProgressBar.h"

@interface AFBlipCaptureViewProgressBar () {
    
    CGFloat _percentage;
    UIView *_fillView;
}

@end

@implementation AFBlipCaptureViewProgressBar

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self createBackground];
        [self createFillView];
    }
    return self;
}

- (void)createBackground {
 
    self.clipsToBounds = YES;
}

- (void)createFillView {
    
    _fillView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
    _fillView.backgroundColor = [UIColor afBlipOrangeSecondaryColor];
    [self addSubview:_fillView];
}

#pragma mark - Animations
- (void)updateToPercentage:(CGFloat)percentage {
    
    _percentage = percentage;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    CGRect frame     = _fillView.frame;
    frame.size.width = CGRectGetWidth(self.bounds) * _percentage;
    _fillView.frame  = frame;
}

@end