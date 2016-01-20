//
//  AFBlipConnectionsHeaderCell.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-27.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionsHeaderCell.h"
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFDynamicFontMediator.h"

@interface AFBlipConnectionsHeaderCell() <AFDynamicFontMediatorDelegate> {
    UILabel* _titleLabel;
    AFDynamicFontMediator   *_dynamicFont;
}

@end

@implementation AFBlipConnectionsHeaderCell

static const NSInteger titleXMargin = 7;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:kAFBlipProfileViewControllerStaticsCollectionViewCell_BackgroundWhiteAlpha];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleXMargin, 0, self.frame.size.width-titleXMargin, self.frame.size.height)];
        _titleLabel.textColor = [UIColor colorWithWhite:95 alpha:1];
        _titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipConnectionHeaderNameSizeOffset];
        [self addSubview:_titleLabel];
        [self createDynamicFont];
    }
    return self;
}

- (void)setHeaderText:(NSString *)headerText {
    _titleLabel.text = headerText;
}

#pragma mark - Dynamic font
- (void)createDynamicFont {
    
    _dynamicFont          = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    
    _titleLabel.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:kAFBlipConnectionHeaderNameSizeOffset];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _titleLabel.text = nil;
}

@end