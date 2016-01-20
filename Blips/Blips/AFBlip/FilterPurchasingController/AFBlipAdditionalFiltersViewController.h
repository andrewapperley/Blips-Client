//
//  AFBlipAdditionalFiltersViewController.h
//  Blips
//
//  Created by Andrew Apperley on 2014-09-22.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseFullScreenModalViewController.h"

@class AFBlipAdditionalFiltersViewController;

typedef void(^AFBlipAdditionalFiltersLoadedBlock)(__weak AFBlipAdditionalFiltersViewController *controller);
typedef void(^AFBlipAdditionalFiltersTransactionComplete)(void);
@interface AFBlipAdditionalFiltersViewController : AFBlipBaseFullScreenModalViewController

- (instancetype)initWithToolbarWithTitle:(NSString *)title leftButton:(NSString *)leftButtonTitle rightButton:(NSString *)rightButtonTitle loadedBlock:(AFBlipAdditionalFiltersLoadedBlock)loaded transactionComplete:(AFBlipAdditionalFiltersTransactionComplete)completion;

@end