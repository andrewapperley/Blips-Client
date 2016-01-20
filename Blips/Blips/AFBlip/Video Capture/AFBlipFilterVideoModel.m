//
//  AFBlipFilterVideoModel.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFilterVideoModel.h"

@implementation AFBlipFilterVideoModel

+ (instancetype)filterModelWithClassName:(NSString *)className title:(NSString *)title image:(NSString *)imageName {
    AFBlipFilterVideoModel *model = [[AFBlipFilterVideoModel alloc] init];
    model.filterClass = className;
    model.filterTitle = title;
    model.filterImage = [UIImage imageNamed:imageName];
    return model;
};

@end