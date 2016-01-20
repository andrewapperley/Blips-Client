//
//  AFBlipActivityIndicator.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-06-28.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AFBlipActivityIndicatorType) {
    
    AFBlipActivityIndicatorType_Small,
    AFBlipActivityIndicatorType_Large
};

@interface AFBlipActivityIndicator : UIView

- (instancetype)initWithStyle:(AFBlipActivityIndicatorType)type;
- (void)startAnimating;
- (void)stopAnimating;

@end