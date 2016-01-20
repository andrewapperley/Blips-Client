//
//  AFBlipGalleryCollectionViewCell.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-22.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipGalleryCollectionViewCell.h"
#import "UIFont+AFBlipFont.h"
#import "AFDynamicFontMediator.h"

const NSInteger kAFBlipGalleryTitleSpacing = 7;

@interface AFBlipGalleryCollectionViewCell () <AFDynamicFontMediatorDelegate> {
    UILabel *_galleryItemTitle;
    UIImageView *_galleryItemImageView;
    AFDynamicFontMediator *_dynamicFont;
    CGFloat _positionX;
}

@end

@implementation AFBlipGalleryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _galleryItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _galleryItemImageView.contentMode = UIViewContentModeScaleAspectFill;
        _galleryItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_galleryItemImageView.frame) + kAFBlipGalleryTitleSpacing, frame.size.width, 10)];
        _galleryItemTitle.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1];
        _galleryItemTitle.textAlignment = NSTextAlignmentCenter;
        _galleryItemTitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_galleryItemTitle];
        [self.contentView addSubview:_galleryItemImageView];
        [self createDynamicFont];
    }
    return self;
}

- (void)updateCellWithObject:(AFBlipGalleryObject *)object {
    
    if(!object) {
        return;
    }

    _galleryItemTitle.text = object.objectTitle;
    [_galleryItemTitle sizeToFit];
    _galleryItemTitle.frame = CGRectMake((self.contentView.frame.size.width - _galleryItemTitle.frame.size.width)/2, _galleryItemTitle.frame.origin.y, _galleryItemTitle.frame.size.width, _galleryItemTitle.frame.size.height);
    
    _galleryItemImageView.image = object.objectImage;
}

- (void)createDynamicFont {
    
    _dynamicFont = [[AFDynamicFontMediator alloc] init];
    _dynamicFont.delegate = self;
    [_dynamicFont updateFontSize];
}

- (void)updatePositionX:(CGFloat)positionX {
    
    _positionX = positionX;
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _galleryItemImageView.image = nil;
    _galleryItemTitle.text      = nil;
}

#pragma mark - AFDynamicFontMediatorDelegate
- (void)dynamicFontMediatorDidChangeFontSize:(AFDynamicFontMediator *)dynamicFontMediator {
    [self updateUIAfterFontSizeChange];
}

- (void)updateUIAfterFontSizeChange {
    _galleryItemTitle.font = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:1 maxSize:20.0f];
    [_galleryItemTitle sizeToFit];
    _galleryItemTitle.frame = CGRectMake(0, CGRectGetMaxY(_galleryItemImageView.frame) + kAFBlipGalleryTitleSpacing, self.frame.size.width, _galleryItemTitle.frame.size.height);
    [self sizeToFit];
}

#pragma mark - Layout subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //Position title
    CGRect titleFrame = _galleryItemTitle.frame;
    titleFrame.origin.x = (self.contentView.frame.size.width - _galleryItemTitle.frame.size.width) / 2 + (_positionX * 100);
    _galleryItemTitle.frame = titleFrame;
}

@end