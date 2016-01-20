//
//  AFBlipInitialViewControllerSignInUpBaseView.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-19.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipInitialViewControllerSignInUpBaseViewHeader.h"

@class AFBlipInitialViewControllerSignInUpBaseView;
@class AFBlipInitialViewUserModel;

@protocol AFBlipInitialViewControllerSignInUpBaseViewDelegate <NSObject>

@optional
- (void)initialViewControllerSignInUpBaseViewDidPressHeaderForView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView;

- (void)initialViewControllerSignInUpBaseView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView didSelectSubmitButtonWithData:(AFBlipInitialViewUserModel *)data;

- (void)initialViewControllerSignInUpBaseView:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView didResetPasswordWithEmail:(NSString *)email;

- (void)initialViewControllerSignUpViewContentViewDidPressTerms:(AFBlipInitialViewControllerSignInUpBaseView *)initialViewControllerSignInUpBaseView;

@end

@interface AFBlipInitialViewControllerSignInUpBaseView : UIView {
    
    @public
    AFBlipInitialViewUserModel                          *_model;
    
    @protected
    AFBlipInitialViewControllerSignInUpBaseViewHeader   *_header;
}

@property (nonatomic, weak) id<AFBlipInitialViewControllerSignInUpBaseViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UIButton *submitButton;

@end