//
//  UIImageView+AFBlipImageView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "UIImageView+AFBlipImageView.h"

const NSTimeInterval kUIImageView_animationDurationIn = 0.2f;

@implementation UIImageView (UIImageView_AFBlipImageView)

- (void)setImage:(UIImage *)image animated:(BOOL)animated {
    
    self.contentMode = UIViewContentModeScaleAspectFit;

    if(!animated) {
        [self setImage:image];
        return;
    }
    
    UIImageView __block *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image                = image;
    imageView.contentMode          = UIViewContentModeScaleAspectFit;
    imageView.alpha                = 0;
    [self addSubview:imageView];

    typeof(self) __weak weakSelf   = self;
    
    [UIView animateWithDuration:kUIImageView_animationDurationIn delay:0.0f options: UIViewAnimationOptionCurveEaseOut animations:^{
        
        imageView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        weakSelf.image = image;
        [imageView removeFromSuperview];
    }];
}

@end