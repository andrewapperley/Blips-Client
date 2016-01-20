//
//  AFRotatingMenuCollectionViewCell.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipPopoutMenuCollectionViewCell.h"
#import "AFBlipPopoutMenuStatics.h"
#import "UIFont+AFBlipFont.h"
@interface AFBlipPopoutMenuCollectionViewCell() {
    UIImageView* _iconView;
}

@end

static NSInteger const kAFBlipMenuTextYMargin = 2;

@implementation AFBlipPopoutMenuCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconView                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAFBlipPopoutMenuCollectionViewCellIconSize, kAFBlipPopoutMenuCollectionViewCellIconSize)];
        _iconView.layer.cornerRadius    = _iconView.frame.size.width * 0.5f;
        _iconView.contentMode           = UIViewContentModeScaleAspectFit;
        _iconView.clipsToBounds         = YES;
        _iconView.backgroundColor       = [UIColor clearColor];
        [self.contentView addSubview:_iconView];
        _menuItemTitleLabel             = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconView.frame) + kAFBlipMenuTextYMargin,kAFBlipPopoutMenuCollectionViewCellIconSize, kAFBlipPopoutMenuCollectionViewCellIconSize/2)];
        _menuItemTitleLabel.textAlignment = NSTextAlignmentCenter;
        _menuItemTitleLabel.textColor   = [UIColor whiteColor];
        _menuItemTitleLabel.font        = [UIFont fontWithType:AFBlipFontType_Helvetica sizeOffset:-3];
        _menuItemTitleLabel.alpha       = 0.5f;
        [self.contentView addSubview:_menuItemTitleLabel];
        self.alpha                      = 0.5f;
        self.clipsToBounds              = NO;
    }
    return self;
}

- (void)updateCell:(UIImage *)icon text:(NSString *)title {
    _iconView.image = icon;
    _menuItemTitleLabel.text = title;
    [_menuItemTitleLabel sizeToFit];
    _menuItemTitleLabel.frame = CGRectMake((self.frame.size.width - _menuItemTitleLabel.frame.size.width)/2, _menuItemTitleLabel.frame.origin.y, _menuItemTitleLabel.frame.size.width, _menuItemTitleLabel.frame.size.height);
    self.alpha = 0.5f;
}

- (void)setSelectedState {
    [self setAlpha:1];
    [_menuItemTitleLabel setAlpha:1];
}

- (void)setUnSelectedState {
    [self setAlpha:0.5];
    [_menuItemTitleLabel setAlpha:0.5f];
}

@end
