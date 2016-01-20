//
//  AFBlipInitialViewControllerBackgroundView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerBackgroundView.h"
#import "AFBlipIntialViewControllerBackgroundViewMotionEffectsDots.h"
#import "AFDynamicFontMediator.h"
#import "UIFont+AFBlipFont.h"

#pragma mark - Constants
//Background
const CGFloat kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountX                      = 100.0f;
const CGFloat kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountY                      = 50.0f;
const NSUInteger kAFBlipIntialViewControllerBackgroundView_NumberOfMotionEffectDotsPerScreenWidth = 1;

//Header
const CGFloat kAFBlipIntialViewControllerBackgroundView_LogoY                                     = 53.0f;
const CGFloat kAFBlipIntialViewControllerBackgroundView_CatchPhraseYBuffer                        = 10.0f;
const CGFloat kAFBlipIntialViewControllerBackgroundView_CatchPhraseXBuffer                        = 10.0f;

//Sign in / up buttons
const CGFloat kAFBlipIntialViewControllerBackgroundView_ButtonsPaddingX                           = 55.0f;
const CGFloat kAFBlipIntialViewControllerBackgroundView_ButtonsPaddingY                           = 60.0f;
const CGFloat kAFBlipIntialViewControllerBackgroundView_ButtonsTopInset                           = 28.0f;

@interface AFBlipInitialViewControllerBackgroundView () <AFDynamicFontMediatorDelegate> {
    
    AFDynamicFontMediator   *_dynamicFontMediator;
    
    NSArray                 *_dots;
    
    UILabel                 *_logoLabel;
    UILabel                 *_AFBlipCatchPhraseLabel;
    
    UIButton* _signupButton;
    UIButton* _signinButtonn;
}

@end

@implementation AFBlipInitialViewControllerBackgroundView

#pragma mark - Init 
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createBackgroundImageView];
        [self createMoitionEffectDots];
        [self createLogoAndCatchPhrase];
        [self createButtons];
        [self createDynamicFontMediator];
    }
    return self;
}

#pragma mark - Dynamic font
- (void)createDynamicFontMediator {
    
    _dynamicFontMediator          = [[AFDynamicFontMediator alloc] init];
    _dynamicFontMediator.delegate = self;
    [_dynamicFontMediator updateFontSize];
}

#pragma mark - Create background image view
- (void)createBackgroundImageView {
    
    //Create background
    UIImageView *appBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFBlipBlurredBackgroundPurple"]];
    appBackgroundImage.frame = CGRectMake(0, 0, appBackgroundImage.frame.size.width + (kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountX * 2), appBackgroundImage.frame.size.height + (kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountY * 2));
    appBackgroundImage.center = self.center;
    [self insertSubview:appBackgroundImage atIndex:0];
    
    //Create motion effects for background
    //Horizontal effect
    UIInterpolatingMotionEffect *motionEffectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffectHorizontal.minimumRelativeValue         = @( - kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountX);
    motionEffectHorizontal.maximumRelativeValue         = @( kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountX);
    
    //Vertical effect
    UIInterpolatingMotionEffect *motionEffectVertical   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectVertical.minimumRelativeValue           = @( - kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountY);
    motionEffectVertical.maximumRelativeValue           = @( kAFBlipIntialViewControllerBackgroundView_MotionEffectsAmountY);
    
    UIMotionEffectGroup *motionEffectGroup              = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects                     = @[motionEffectHorizontal, motionEffectVertical];
    
    [appBackgroundImage addMotionEffect:motionEffectGroup];
}

#pragma mark - Create motion effet dots
- (void)createMoitionEffectDots {
    
    CGFloat widthHeight     = 4.0f;
    NSUInteger numberOfRows = afRound(CGRectGetHeight(self.bounds) / widthHeight);
    NSUInteger totalDots    = numberOfRows * kAFBlipIntialViewControllerBackgroundView_NumberOfMotionEffectDotsPerScreenWidth;

    CGFloat posX            = 0.0f;
    CGFloat posY            = 0.0f;
    CGFloat posXMax         = CGRectGetWidth(self.bounds);
    CGFloat posYMax         = CGRectGetHeight(self.bounds);

    NSMutableArray *dots    = [[NSMutableArray alloc] initWithCapacity:totalDots];
    for(NSUInteger i = 0; i < totalDots; i++) {
        
        posX = afFloor(arc4random_uniform(posXMax));
        posY = afFloor(arc4random_uniform(posYMax));
        
        AFBlipIntialViewControllerBackgroundViewMotionEffectsDots *dot = [[AFBlipIntialViewControllerBackgroundViewMotionEffectsDots alloc] initWithFrame:CGRectMake(posX, posY, widthHeight, widthHeight)];
        dot.layer.cornerRadius                                         = CGRectGetHeight(dot.frame);
        dot.layer.masksToBounds                                        = YES;
        [self addSubview:dot];
        
        [dots addObject:dot];
    }
    
    _dots = [[NSArray alloc] initWithArray:dots];
}

#pragma mark - Create header
- (void)createLogoAndCatchPhrase {
    
    //Logo
    _logoLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, kAFBlipIntialViewControllerBackgroundView_LogoY, CGRectGetWidth(self.bounds), 0)];
    _logoLabel.textColor        = [UIColor whiteColor];
    _logoLabel.textAlignment    = NSTextAlignmentCenter;
    _logoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _logoLabel.text             = NSLocalizedString(@"AFBlipSettingsMenuLogoutAlertTitle", nil);
    [self addSubview:_logoLabel];
    
    //Logo
    _logoLabel.font = [UIFont fontWithName:@"Noteworthy-Light" size:37];
    [_logoLabel sizeToFit];
    
    CGRect frame     = _logoLabel.frame;
    frame.size.width = CGRectGetWidth(self.bounds);
    _logoLabel.frame = frame;
    
    //Catch phrase
    _AFBlipCatchPhraseLabel                 = [[UILabel alloc] init];
    _AFBlipCatchPhraseLabel.text            = NSLocalizedString(@"AFBlipInitialViewCreating", nil);
    _AFBlipCatchPhraseLabel.textAlignment   = NSTextAlignmentCenter;
    _AFBlipCatchPhraseLabel.backgroundColor = [UIColor clearColor];
    _AFBlipCatchPhraseLabel.textColor       = [UIColor colorWithRed:0.853 green:0.886 blue:0.886 alpha:1.000];
    _AFBlipCatchPhraseLabel.numberOfLines   = 0;
    
    [self addSubview:_AFBlipCatchPhraseLabel];
}

#pragma mark - Create buttons
- (void)createButtons {
    
    /*Signup Button*/
    UIImage* signupButtonImage                         = [UIImage imageNamed:@"AFBlipSignupButton"];
    UIImage* signupButtonDownImage                     = [UIImage imageNamed:@"AFBlipSignUpButtonDownState"];
    _signupButton                                      = [[UIButton alloc] init];
    _signupButton.autoresizingMask                     = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [_signupButton setBackgroundImage:signupButtonImage forState:UIControlStateNormal];
    [_signupButton setBackgroundImage:signupButtonDownImage forState:UIControlStateHighlighted];
    [_signupButton setTitle:NSLocalizedString(@"AFBlipInitialViewSignUp", nil) forState:UIControlStateNormal];
    [_signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signupButton addTarget:self action:@selector(onSignupButton) forControlEvents:UIControlEventTouchUpInside];
    _signupButton.titleLabel.numberOfLines             = 0;
    _signupButton.titleLabel.lineBreakMode             = NSLineBreakByWordWrapping;
    _signupButton.titleLabel.textAlignment             = NSTextAlignmentCenter;
    [_signupButton sizeToFit];
    
    //Frame
    _signupButton.frame           = CGRectMake(kAFBlipIntialViewControllerBackgroundView_ButtonsPaddingX, CGRectGetHeight(self.bounds) - CGRectGetHeight(_signupButton.frame) - kAFBlipIntialViewControllerBackgroundView_ButtonsPaddingY, CGRectGetWidth(_signupButton.frame), CGRectGetHeight(_signupButton.frame));
    _signupButton.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(_signupButton.frame) + kAFBlipIntialViewControllerBackgroundView_ButtonsTopInset, 0, 0, 0);
    [self addSubview:_signupButton];

    /*Signin Button*/
    UIImage* signinButtonImage                          = [UIImage imageNamed:@"AFBlipSigninButton"];
    UIImage* signinButtonDownImage                      = [UIImage imageNamed:@"AFBlipSignInButtonDownState"];
    _signinButtonn                                      = [[UIButton alloc] init];
    _signinButtonn.autoresizingMask                     = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [_signinButtonn setBackgroundImage:signinButtonImage forState:UIControlStateNormal];
    [_signinButtonn setBackgroundImage:signinButtonDownImage forState:UIControlStateHighlighted];
    [_signinButtonn setTitle:NSLocalizedString(@"AFBlipInitialViewSignIn", nil) forState:UIControlStateNormal];
    [_signinButtonn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signinButtonn addTarget:self action:@selector(onSigninButton) forControlEvents:UIControlEventTouchUpInside];
    _signinButtonn.titleLabel.numberOfLines             = 0;
    _signinButtonn.titleLabel.lineBreakMode             = NSLineBreakByWordWrapping;
    _signinButtonn.titleLabel.textAlignment             = NSTextAlignmentCenter;
    [_signinButtonn sizeToFit];

    //Frame
    _signinButtonn.frame           = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_signinButtonn.frame) -  kAFBlipIntialViewControllerBackgroundView_ButtonsPaddingX, CGRectGetHeight(self.bounds) - CGRectGetHeight(_signinButtonn.frame) - kAFBlipIntialViewControllerBackgroundView_ButtonsPaddingY, CGRectGetWidth(_signinButtonn.frame), CGRectGetHeight(_signinButtonn.frame));
    _signinButtonn.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(_signinButtonn.frame) + kAFBlipIntialViewControllerBackgroundView_ButtonsTopInset, 0, 0, 0);
    [self addSubview:_signinButtonn];
}

- (void)onSignupButton {
    
    [_delegate initialViewControllerBackgroundViewDidPressSignUp:self];
}

- (void)onSigninButton {
    
    [_delegate initialViewControllerBackgroundViewDidPressSignIn:self];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {

    //Catch phrase label
    _AFBlipCatchPhraseLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1.5f];

    CGSize maxSize                = CGSizeMake(CGRectGetWidth(self.bounds) - (kAFBlipIntialViewControllerBackgroundView_CatchPhraseXBuffer * 2), CGFLOAT_MAX);
    NSDictionary *attributes      = @{NSFontAttributeName: _AFBlipCatchPhraseLabel.font};
    CGRect catchPhraseFrame       = [_AFBlipCatchPhraseLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];

    _AFBlipCatchPhraseLabel.frame = CGRectMake(kAFBlipIntialViewControllerBackgroundView_CatchPhraseXBuffer, CGRectGetMaxY(_logoLabel.frame) +  kAFBlipIntialViewControllerBackgroundView_CatchPhraseYBuffer, maxSize.width, catchPhraseFrame.size.height);
    
    //Sign up / in buttons
    _signupButton.titleLabel.font  = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
    _signinButtonn.titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
}

#pragma mark - Enable motion effects
- (void)setEnabledMotionEffects:(BOOL)enabledMotionEffects {
    
    for(AFBlipIntialViewControllerBackgroundViewMotionEffectsDots *dot in _dots) {
        
        dot.enableMotionEffects = enabledMotionEffects;
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
