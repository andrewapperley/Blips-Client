//
//  AFBlipFilterVideoModel.h
//  Blips
//
//  Created by Andrew Apperley on 2014-08-08.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFBlipFilterVideoModel : NSObject

@property(nonatomic, strong)NSString *filterClass;
@property(nonatomic, strong)NSString *filterTitle;
@property(nonatomic, strong)UIImage *filterImage;

+ (instancetype)filterModelWithClassName:(NSString *)className title:(NSString *)title image:(NSString *)imageName;

@end