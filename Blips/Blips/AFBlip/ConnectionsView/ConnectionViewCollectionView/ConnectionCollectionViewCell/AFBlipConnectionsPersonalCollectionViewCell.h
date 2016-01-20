//
//  AFBlipConnectionsPersonalCollectionViewCell.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-24.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipConnectionsPersonalModel.h"

@interface AFBlipConnectionsPersonalCollectionViewCell : UICollectionViewCell

- (void)createPersonalCellWithModel:(AFBlipConnectionsPersonalModel *)model;

@end