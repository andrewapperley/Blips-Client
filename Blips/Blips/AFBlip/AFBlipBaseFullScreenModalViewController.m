//
//  AFBlipBaseFullScreenModalViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-05-01.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseFullScreenModalViewController.h"
#import "AFDynamicFontMediator.h"

@interface AFBlipBaseFullScreenModalViewController () <AFDynamicFontMediatorDelegate> {
    AFDynamicFontMediator *_dynamicFont;
    NSString* _title;
    NSString* _leftButtonTitle;
    NSString* _rightButtonTitle;
    UILabel* _titleLabel;
}

@end

@implementation AFBlipBaseFullScreenModalViewController

//Toolbar
const NSInteger kAFBlipEditProfileTitleOffsetY                 = 26;
const NSInteger kAFBlipEditProfileToolbarHeight                = 65;

//Bottom border
const CGFloat kAFBlipBaseFullScreenModalViewController_Border  = 1.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFBlipHeaderBackground"]];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, kAFBlipEditProfileToolbarHeight)];
    _toolBar.clipsToBounds = YES;
    [_toolBar addSubview:headerImageView];
    
    UIBarButtonItem* leftButton;
    UIBarButtonItem* rightButton;
    
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:2];
    
    leftButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction)];
    leftButton.tintColor = [UIColor whiteColor];
    [buttons addObject:leftButton];
    
    if (_leftButtonTitle) {
        leftButton.title = _leftButtonTitle;
    }
    
    UIBarButtonItem* flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    rightButton = [[UIBarButtonItem alloc] initWithTitle:_rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    rightButton.tintColor = [UIColor whiteColor];
    [buttons addObject:flex];
    [buttons addObject:rightButton];
    
    if (_rightButtonTitle) {
        rightButton.title = _rightButtonTitle;
    }
    
    [_toolBar setItems:buttons animated:YES];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kAFBlipEditProfileTitleOffsetY, [[UIScreen mainScreen] bounds].size.width, _toolBar.frame.size.height/2)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _title;
    _titleLabel.font = [UIFont fontWithType:AFBlipFontType_NavBarTitle sizeOffset:7];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.userInteractionEnabled = NO;
    
    [self.view addSubview:_toolBar];
    [_toolBar addSubview:_titleLabel];
    
    //Bottom border
    UIView *border         = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_toolBar.frame) - kAFBlipBaseFullScreenModalViewController_Border, CGRectGetWidth(_toolBar.frame), kAFBlipBaseFullScreenModalViewController_Border)];
    border.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:border];
    
    UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFBlipBlurredBackgroundPurple"]];
    
    [self.view insertSubview:background atIndex:0];
}

- (instancetype)initWithToolbarWithTitle:(NSString *)title leftButton:(NSString *)leftButtonTitle rightButton:(NSString *)rightButtonTitle {
    
    if (self = [super init]) {
        
        _leftButtonTitle  = leftButtonTitle;
        _rightButtonTitle = rightButtonTitle;
        _title            = title;
        
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
    
    _titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:4];
    
    [self dynamicFontMediatorDidChangeFontSize];
}

- (void)dynamicFontMediatorDidChangeFontSize {
    /** Override this */
}

- (void)leftButtonAction {
    /** Override this */
}

- (void)rightButtonAction {
    /** Override this */
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateLabels:(NSString *)leftLabel rightLabel:(NSString *)rightLabel title:(NSString *)title {

    _title = title;
    _titleLabel.text = title;
    
    _leftButtonTitle = leftLabel;
    [_toolBar.items.firstObject setTitle:(leftLabel) ? leftLabel : @""];
    
    _rightButtonTitle = rightLabel;
    [_toolBar.items.lastObject setTitle:(rightLabel) ? rightLabel : @""];
}

@end
