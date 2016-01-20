//
//  AFRotatingMenuDataSourceItemFactory.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipPopoutMenuControllerModel.h"

@interface AFBlipPopoutMenuDataSourceItemFactory : NSObject

+ (NSArray *)generateMenuItemsFromMenuModel:(AFBlipPopoutMenuControllerModel *)model;

@end