//
//  AFBlipConnectionsPersonalModel.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-24.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionsPersonalModel.h"

@implementation AFBlipConnectionsPersonalModel

+ (instancetype)createPersonalModelWithSectionName:(NSString *)name sectionImage:(UIImage *)image section:(kAFBlipConnectionsPersonalSection)section {
    AFBlipConnectionsPersonalModel* model = [[AFBlipConnectionsPersonalModel alloc] init];
    model.section       = section;
    model.sectionImage  = image;
    model.sectionName   = name;
    return model;
}

@end