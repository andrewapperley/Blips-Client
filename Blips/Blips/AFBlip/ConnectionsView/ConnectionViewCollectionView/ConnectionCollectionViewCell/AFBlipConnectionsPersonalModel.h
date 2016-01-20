//
//  AFBlipConnectionsPersonalModel.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-24.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipConnectionsViewControllerStatics.h"

@interface AFBlipConnectionsPersonalModel : NSObject

@property(nonatomic, strong)NSString* sectionName;
@property(nonatomic, strong)UIImage* sectionImage;
@property(nonatomic)kAFBlipConnectionsPersonalSection section;

+ (instancetype)createPersonalModelWithSectionName:(NSString *)name sectionImage:(UIImage *)image section:(kAFBlipConnectionsPersonalSection)section;

@end