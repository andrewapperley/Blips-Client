//
//  AFRotatingMenuViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFBlipPopoutMenuViewController.h"
#import "AFBlipPopoutMenuDataSource.h"
#import "AFBlipPopoutMenuCollectionViewCell.h"
#import "AFBlipPopoutMenuStatics.h"
#import "AFBlipPopoutMenuMenuItem.h"
#import "AFBlipPopoutMenuCollectionView.h"

@interface AFBlipPopoutMenuViewController () <UICollectionViewDelegate, UIScrollViewDelegate> {
    AFBlipPopoutMenuCollectionView* _rotatingCollectionView;
    AFBlipPopoutMenuDataSource* _datasource;
    AFBlipPopoutMenuControllerModel* _currentModel;
    CGRect _menuFrame;
    NSInteger _selectedItem;
}

@end

@implementation AFBlipPopoutMenuViewController

#pragma mark - Init methods

- (instancetype)initWithModel:(AFBlipPopoutMenuControllerModel *)model frame:(CGRect)frame {
    if (self = [super init]) {
        _currentModel           = model;
        _menuFrame              = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = _menuFrame;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [layout setSectionInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    _rotatingCollectionView = [[AFBlipPopoutMenuCollectionView alloc] initWithFrame:CGRectMake(0, 0, _menuFrame.size.width, _menuFrame.size.height) collectionViewLayout:layout];
    _rotatingCollectionView.clipsToBounds = NO;
    _datasource = [[AFBlipPopoutMenuDataSource alloc] init];
    [_datasource setMenuItemsWithModel:_currentModel];
    [_rotatingCollectionView setDelegate:self];
    [_rotatingCollectionView setDataSource:_datasource];
    [_rotatingCollectionView registerClass:[AFBlipPopoutMenuCollectionViewCell class] forCellWithReuseIdentifier:kAFBlipPopoutMenuCollectionViewCellId];
    [self.view addSubview:_rotatingCollectionView];
}

#pragma mark - Public Menu methods

- (void)refreshMenuWithModel:(AFBlipPopoutMenuControllerModel *)model {
    if (_currentModel) {
        _currentModel = model;
    }
    [_datasource setMenuItemsWithModel:_currentModel];
    [_rotatingCollectionView reloadData];
}

- (void)unhighlightItem {
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    [_rotatingCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    AFBlipPopoutMenuCollectionViewCell* cell = (AFBlipPopoutMenuCollectionViewCell *)[_rotatingCollectionView cellForItemAtIndexPath:indexPath];
    [cell setUnSelectedState];
}

- (void)highlightItemAtIndex:(NSInteger)index {
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_rotatingCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    AFBlipPopoutMenuCollectionViewCell* cell = (AFBlipPopoutMenuCollectionViewCell *)[_rotatingCollectionView cellForItemAtIndexPath:indexPath];
    [cell setSelectedState];
    _selectedItem = index;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self highlightItemAtIndex:_selectedItem];
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self unhighlightItem];
    [self highlightItemAtIndex:indexPath.row];
    
    if ([_delegate respondsToSelector:(SEL)((AFBlipPopoutMenuMenuItem *)_datasource.menuItems[indexPath.row]).menuItemSelector]) {
        /** ARC requires enough info about the method so it can enforce proper MM rules. */
        __weak AFBlipPopoutMenuMenuItem* item    = (AFBlipPopoutMenuMenuItem *)_datasource.menuItems[indexPath.row];
        SEL _selector               = (SEL)item.menuItemSelector;
        IMP imp                     = [_delegate methodForSelector:_selector];
        void (*func)(id, SEL, id)   = (void *)imp;
        func(_delegate, _selector, item);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:_selectedItem inSection:0];
    [_rotatingCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    AFBlipPopoutMenuCollectionViewCell* cell = (AFBlipPopoutMenuCollectionViewCell *)[_rotatingCollectionView cellForItemAtIndexPath:indexPath];
    [cell setSelectedState];
}

#pragma mark - Cleanup

- (void)dealloc {
    _delegate                           = nil;
    _rotatingCollectionView.delegate    = nil;
    _rotatingCollectionView.dataSource  = nil;
}

@end