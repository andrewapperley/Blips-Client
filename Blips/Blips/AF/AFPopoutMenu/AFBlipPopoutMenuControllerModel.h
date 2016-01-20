//
//  AFRotatingMenuControllerModel.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipPopoutMenuControllerModel : NSObject

@property(nonatomic, strong)NSArray* icons;
@property(nonatomic, strong)NSArray* titles;
@property(nonatomic, strong)NSArray* selectors;
@property(nonatomic, strong)NSArray* properties;

- (instancetype)initWithIcons:(NSArray *)icons titles:(NSArray *)titles selectors:(NSArray *)selectors properties:(NSArray *)properties;

@end