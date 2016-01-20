//
//  UIButton+AFBlipButton.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "UIButton+AFBlipButton.h"

const NSTimeInterval kUIButton_AFBlipButton_animationDurationIn = 0.2f;

@implementation UIButton (UIButton_AFBlipButton)

- (void)setImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated {
    
    if(!animated) {
        [self setImage:image forState:state];
        return;
    }
    
    UIImageView __block *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image                = image;
    imageView.alpha                = 0;
    [self addSubview:imageView];
    
    typeof(self) __weak weakSelf   = self;
    
    [UIView animateWithDuration:kUIButton_AFBlipButton_animationDurationIn delay:0.0f options: UIViewAnimationOptionCurveEaseOut animations:^{
        
        imageView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [weakSelf setImage:image forState:state];
        [imageView removeFromSuperview];
    }];
}

@end