//
//  AFRotatingMenuDataSource.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFBlipPopoutMenuControllerModel;

@interface AFBlipPopoutMenuDataSource : NSObject <UICollectionViewDataSource>

@property(nonatomic, strong, readonly)NSArray* menuItems;
- (void)setMenuItemsWithModel:(AFBlipPopoutMenuControllerModel *)model;

@end