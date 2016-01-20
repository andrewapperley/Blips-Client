//
//  AFBlipTermsModal.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-20.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipTermsModal.h"

@interface AFBlipTermsModal () {
    
    UIScrollView *_scrollView;
    UILabel      *_termsLabel;
}

@end

@implementation AFBlipTermsModal

#pragma mark - Init
- (instancetype)init {
    
    self = [super initWithToolbarWithTitle:[AFBlipTermsModal title] leftButton:nil rightButton:[AFBlipTermsModal rightButtonTitle]];
    if(self) {
        [self createScrollViewAndText];
    }
    return self;
}

- (void)createScrollViewAndText {
    
    //Scroll view
    CGRect frame                          = CGRectMake(0, kAFBlipEditProfileToolbarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kAFBlipEditProfileToolbarHeight);
    _scrollView                           = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.autoresizingMask          = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _scrollView.backgroundColor           = [UIColor whiteColor];
    [self.view addSubview:_scrollView];

    //Text
    NSString *termsText                   = [self termsAndConditionsString];

    _termsLabel                           = [[UILabel alloc] init];
    _termsLabel.autoresizingMask          = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _termsLabel.textColor                 = [UIColor lightGrayColor];
    _termsLabel.numberOfLines             = 0;
    _termsLabel.text                      = termsText;
    
    [_scrollView addSubview:_termsLabel];
    
    [self dynamicFontMediatorDidChangeFontSize];
}

#pragma mark - Dynamic font
- (void)dynamicFontMediatorDidChangeFontSize {
    
    if(!_scrollView || !_termsLabel) {
        return;
    }
    
    //Text
    CGFloat fontOffset                    = 1.0f;
    _termsLabel.font                      = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:fontOffset];

    CGFloat horizontalPadding             = 10.0f;
    CGFloat verticalPadding               = [_termsLabel.font capHeight];
    CGSize boundingRectSize               = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - horizontalPadding - (horizontalPadding * 2), CGFLOAT_MAX);

    NSDictionary *termsBoundingDictionary = @{NSFontAttributeName:_termsLabel.font};
    
    CGRect termsFrame                     = [_termsLabel.text boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:termsBoundingDictionary context:nil];
    termsFrame.origin.y                   = verticalPadding;
    termsFrame.origin.x                   = horizontalPadding;
    _termsLabel.frame                     = termsFrame;
    
    //Adjust scrollview content size
    _scrollView.contentSize               = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(termsFrame) + verticalPadding);
}

#pragma mark - Button actions
- (void)rightButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)termsAndConditionsString {
    
    return NSLocalizedString(@"AFBLipTermsModalNavigationTermsAndCondition", nil);
}

#pragma mark - Utilities
+ (NSString *)title {
    
    return NSLocalizedString(@"AFBLipTermsModalNavigationTitle", nil);
}

+ (NSString *)rightButtonTitle {
    
    return NSLocalizedString(@"AFBLipFAQModalCancelButtonTitle", nil);
}

@end