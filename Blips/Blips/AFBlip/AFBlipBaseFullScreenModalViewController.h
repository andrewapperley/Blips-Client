//
//  AFBlipBaseFullScreenModalViewController.h
//  Blips
//
//  Created by Andrew Apperley on 2014-05-01.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFBlipBaseFullScreenModalViewController : UIViewController

extern const NSInteger kAFBlipEditProfileTitleOffsetY;
extern const NSInteger kAFBlipEditProfileToolbarHeight;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (instancetype)initWithToolbarWithTitle:(NSString *)title leftButton:(NSString *)leftButtonTitle rightButton:(NSString *)rightButtonTitle;

- (void)dynamicFontMediatorDidChangeFontSize;
- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)dismissView;
- (void)updateLabels:(NSString *)leftLabel rightLabel:(NSString *)rightLabel title:(NSString *)title;

@property(nonatomic, strong)UIToolbar* toolBar;

@end
