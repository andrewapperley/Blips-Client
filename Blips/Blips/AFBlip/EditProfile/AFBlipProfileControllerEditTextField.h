//
//  AFBlipProfileControllerEditTextField.h
//  Blips
//
//  Created by Andrew Apperley on 2014-04-30.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipInitialViewControllerSignInUpTextField.h"

@interface AFBlipProfileControllerEditTextField : AFBlipInitialViewControllerSignInUpTextField

- (void)setLeftTextFieldText:(NSString *)text;
@property(nonatomic)BOOL editState;

@end
