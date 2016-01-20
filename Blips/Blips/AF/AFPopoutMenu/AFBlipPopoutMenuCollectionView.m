//
//  AFRotatingMenuCollectionView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/21/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipPopoutMenuCollectionView.h"

@implementation AFBlipPopoutMenuCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setDirectionalLockEnabled:YES];
//        [self setPagingEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        [self setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}


@end