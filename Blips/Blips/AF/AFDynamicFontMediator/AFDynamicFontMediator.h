//
//  AFDynamicFontMediator.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-21.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFDynamicFontMediator;

@protocol AFDynamicFontMediatorDelegate <NSObject>

@required
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator;

@end

@interface AFDynamicFontMediator : NSObject

@property (nonatomic, weak) id<AFDynamicFontMediatorDelegate> delegate;

- (void)updateFontSize;

@end