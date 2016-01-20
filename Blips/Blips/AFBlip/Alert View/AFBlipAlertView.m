//
//  AFBlipAlertView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-12.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAlertView.h"
#import "AFDynamicFontMediator.h"
#import "UIImage+ImageEffects.h"

@interface AFBlipAlertView () <AFDynamicFontMediatorDelegate> {
    
    AFDynamicFontMediator   *_dynamicFont;
}

@end

@implementation AFBlipAlertView

#pragma mark - Init
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles {

    return [self initWithStyle:AFFAlertViewStyle_Default title:title message:message buttonTitles:buttonTitles];
}

- (instancetype)initWithStyle:(AFFAlertViewStyle)style title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles {
    
    self = [super initWithStyle:style title:title message:message buttonTitles:buttonTitles];
    if(self) {
        
        self.backgroundColor                        = [UIColor colorWithWhite:0.1f alpha:0.05f];
        self.backgroundBlockerView.backgroundColor  = [UIColor colorWithWhite:0.0f alpha:0.45f];
        self.titleLabel.textColor                   = [UIColor whiteColor];
        self.messageLabel.textColor                 = [UIColor whiteColor];
        self.borderColor                            = [UIColor colorWithWhite:1.0f alpha:0.2f];
        self.selectedStateButtonBackgroundColor     = self.borderColor;
        self.buttonTextColor                        = [UIColor whiteColor];
        self.selectedStateButtonTextColor           = self.buttonTextColor;
        self.secureTextField.keyboardAppearance     = UIKeyboardAppearanceDark;
        
        [self createDynamicFont];
    }
    return self;
}

- (void)createDynamicFont {
    
    _dynamicFont = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {

    UIFont *titleFont            = [UIFont fontWithType:AFBlipFontType_NavBarTitle sizeOffset:2.0f];
    UIFont *buttonFont           = [UIFont fontWithType:AFBlipFontType_NavBarTitle sizeOffset:1.0f];
    self.titleLabel.font         = titleFont;
    self.messageLabel.font       = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-1.5f];
    
    CGRect messageLabelFrame     = [self.messageLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.messageLabel.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.messageLabel.font} context:nil];
    messageLabelFrame.origin.x   = CGRectGetMinX(self.messageLabel.frame);
    messageLabelFrame.origin.y   = CGRectGetMinY(self.messageLabel.frame);
    messageLabelFrame.size.width = CGRectGetWidth(self.bounds) - (messageLabelFrame.origin.x * 2);
    self.messageLabel.frame      = messageLabelFrame;
    
    for(UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
    
    [self setNeedsLayout];
}

#pragma mark - Show in override
- (void)show {
    [super show];
    
    [self createBlurredImage];
}

- (void)createBlurredImage {
    
    __weak typeof(self) weakSelf = self;
    
    UIView __weak *rootView      = [self superViewContainer];

    //Root view
    CGRect __block frame          = CGRectIntegral(rootView.frame);
    
    CGFloat __block posX          = (CGRectGetWidth(rootView.frame) - CGRectGetWidth(self.frame)) * 0.5f;
    CGFloat __block posY          = (CGRectGetHeight(rootView.frame) - CGRectGetHeight(self.frame)) * 0.5f;
    CGRect __block centerFrame    = CGRectIntegral(CGRectMake(posX, posY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)));
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *image        = [AFBlipAlertView screenshotWithViewAndFrame:rootView frame:frame];

        UIImage *blurredImage = [AFBlipAlertView imageWithBlurredFrame:image frame:centerFrame backgroundColor:weakSelf.backgroundColor];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backgroundColor = [UIColor colorWithPatternImage:blurredImage];
        });
    });
}

- (UIView *)superViewContainer {
    
    //Choose the the top subview view of the topmost presented view controller
    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentedViewController].view;
    
    //If not controller is presented then look for the topmost subview of the root view controller.
    if(!rootView) {
        rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    }
    
    return rootView;
}

+ (UIImage *)screenshotWithViewAndFrame:(UIView *)view frame:(CGRect)frame {
    
    UIGraphicsBeginImageContextWithOptions(frame.size, view.opaque, [UIScreen mainScreen].scale);
    
    if([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        
        [view drawViewHierarchyInRect:frame afterScreenUpdates:(view.superview) ? NO : YES];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithBlurredFrame:(UIImage *)image frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor {
    
    frame.size.height   = frame.size.height   * image.scale;
    frame.size.width    = frame.size.width    * image.scale;
    frame.origin.x      = frame.origin.x      * image.scale;
    frame.origin.y      = frame.origin.y      * image.scale;

    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);

    UIImage *blurredCroppedArea = [[UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:image.imageOrientation] applyBlurWithRadius:20.0f tintColor:backgroundColor saturationDeltaFactor:1.0f maskImage:nil];
    
    CGFloat scale       = 0.1f;

    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [blurredCroppedArea drawInRect:frame];
    
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    
    return blurredCroppedArea;
}

@end