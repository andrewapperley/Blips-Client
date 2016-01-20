//
//  AFBlipFilterListCell.h
//  Blips
//
//  Created by Andrew Apperley on 2014-08-13.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kAFBlipFilterCellKey;

@interface AFBlipFilterListCell : UICollectionViewCell

@property(nonatomic, readonly, strong)NSString *filterTitle;
@property(nonatomic, readonly, strong)UIImage *filterImage;
@property(nonatomic, readonly, strong)NSString *filterClass;

- (void)updateFilterCellWithTitle:(NSString *)filterTitle image:(UIImage *)filterImage class:(NSString *)filterClass;

@end