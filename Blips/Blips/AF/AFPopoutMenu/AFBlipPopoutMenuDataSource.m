//
//  AFRotatingMenuDataSource.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipPopoutMenuDataSource.h"
#import "AFBlipPopoutMenuDataSourceItemFactory.h"
#import "AFBlipPopoutMenuStatics.h"
#import "AFBlipPopoutMenuCollectionViewCell.h"
#import "AFBlipPopoutMenuMenuItem.h"

@implementation AFBlipPopoutMenuDataSource

- (instancetype)init {
    if (self = [super init]) {
        _menuItems = [[NSArray alloc] init];
    }
    return self;
}

- (void)setMenuItemsWithModel:(AFBlipPopoutMenuControllerModel *)model {
    
    _menuItems = [AFBlipPopoutMenuDataSourceItemFactory generateMenuItemsFromMenuModel:model];
    
}

#pragma mark - UICollectionViewDataSource methods

- (AFBlipPopoutMenuCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AFBlipPopoutMenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipPopoutMenuCollectionViewCellId forIndexPath:indexPath];
    
    AFBlipPopoutMenuMenuItem* menuItem = (AFBlipPopoutMenuMenuItem *)_menuItems[indexPath.row];
    
    [cell updateCell:menuItem.menuItemIcon text:menuItem.menuItemTitle];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuItems.count;
}

@end