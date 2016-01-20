//
//  AFRotatingMenuViewController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFBlipPopoutMenuControllerModel;

@interface AFBlipPopoutMenuViewController : UIViewController

@property(nonatomic, weak)id delegate;
@property(nonatomic)BOOL isOpen;

- (instancetype)initWithModel:(AFBlipPopoutMenuControllerModel *)model frame:(CGRect)frame;
- (void)refreshMenuWithModel:(AFBlipPopoutMenuControllerModel *)model;
- (void)highlightItemAtIndex:(NSInteger)index;
@end