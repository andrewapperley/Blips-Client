//
//  AFRotatingMenuCollectionViewCell.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFBlipPopoutMenuCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIImage* icon;
@property(nonatomic, strong)UILabel* menuItemTitleLabel;

- (void)setSelectedState;
- (void)setUnSelectedState;
- (void)updateCell:(UIImage *)icon text:(NSString *)title;
@end