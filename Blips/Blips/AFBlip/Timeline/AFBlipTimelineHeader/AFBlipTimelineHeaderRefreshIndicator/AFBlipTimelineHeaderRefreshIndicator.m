//
//  AFBlipTimelineHeaderRefreshIndicator.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-09-06.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTimelineHeaderRefreshIndicator.h"

@interface AFBlipTimelineHeaderRefreshIndicator () {
    
    UIImageView *_imageView;
    UIView      *_bottomBorder;
}

@end

@implementation AFBlipTimelineHeaderRefreshIndicator

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView {
    
    _imageView                  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlipsTimelineRefreshIndicator"]];
    _imageView.center           = self.center;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_imageView];
    
    CGRect frame     = _imageView.frame;
    frame.origin.y   = 0;
    _imageView.frame = frame;
}

@end