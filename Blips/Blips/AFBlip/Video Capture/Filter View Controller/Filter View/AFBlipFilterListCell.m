//
//  AFBlipFilterListCell.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-13.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFilterListCell.h"
#import "UIFont+AFBlipFont.h"
#import "UIColor+AFBlipColor.h"
#import "AFDynamicFontMediator.h"

NSString *const kAFBlipFilterCellKey = @"kAFBlipFilterCellKey";

@interface AFBlipFilterListCell () <AFDynamicFontMediatorDelegate> {
    UILabel *_filterTitleLabel;
    UIImageView *_filterImageView;
    AFDynamicFontMediator *_dynamicFont;
}

@end

@implementation AFBlipFilterListCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _filterTitleLabel = [[UILabel alloc] init];
        _filterTitleLabel.text = kAFBlipFilterCellKey;
        _filterTitleLabel.textAlignment = NSTextAlignmentCenter;
        _filterTitleLabel.textColor = [UIColor whiteColor];
        _filterTitleLabel.numberOfLines = 0;
        
        _filterImageView = [[UIImageView alloc] init];
        _filterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _filterImageView.layer.borderWidth = 2;
        _filterImageView.clipsToBounds = YES;
        _filterImageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_filterTitleLabel];
        [self addSubview:_filterImageView];
        
        [self createDyanmicFont];
    }
    
    return self;
}

- (void)updateFilterCellWithTitle:(NSString *)filterTitle image:(UIImage *)filterImage class:(NSString *)filterClass {
    
    [self setValue:filterClass forKey:@"filterClass"];
    [self setValue:filterImage forKey:@"filterImage"];
    [self setValue:filterTitle forKey:@"filterTitle"];
    
    [_filterImageView setImage:filterImage];
    [_filterTitleLabel setText:filterTitle];
}

- (void)setSelected:(BOOL)selected {
    CGColorRef borderColor = [UIColor whiteColor].CGColor;
    if (selected) {
        borderColor = [UIColor afBlipOrangeSecondaryColor].CGColor;
    }
    
    _filterImageView.layer.borderColor = borderColor;
}

- (void)createDyanmicFont {
    
    _dynamicFont = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    _filterTitleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1 maxSize:16.0f];
    
    CGSize size  = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGRect frame = [_filterTitleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _filterTitleLabel.font} context:nil];
    
    _filterTitleLabel.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - CGRectGetHeight(frame), CGRectGetWidth(self.bounds), CGRectGetHeight(frame));
    
    //Image
    NSInteger imageMarginY = 5;
    CGFloat imageHeight = self.frame.size.height - _filterTitleLabel.frame.size.height - imageMarginY;
    
    _filterImageView.frame = CGRectMake((self.frame.size.width - imageHeight) /2, 0, imageHeight, imageHeight);
    _filterImageView.layer.cornerRadius = imageHeight*0.5;
}

@end