//
//  AFBlipGalleryCollectionViewCell.h
//  Blips
//
//  Created by Andrew Apperley on 2014-09-22.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipGalleryObject.h"

@interface AFBlipGalleryCollectionViewCell : UICollectionViewCell

- (void)updateCellWithObject:(AFBlipGalleryObject *)object;
- (void)updateUIAfterFontSizeChange;
- (void)updatePositionX:(CGFloat)positionX;

@end