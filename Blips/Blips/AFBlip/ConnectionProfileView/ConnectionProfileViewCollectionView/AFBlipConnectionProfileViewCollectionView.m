//
//  AFBlipConnectionProfileViewCollectionView.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionProfileViewCollectionView.h"
#import "AFBlipConnectionProfileViewCollectionViewCell.h"

#pragma mark - Constants
const NSUInteger kAFBlipConnectionProfileViewCollectionView_NewTimelineCellIndex = 0;
NSString *const  kAFBlipConnectionProfileViewCollectionView_CellReuseIdentifier  = @"AFBlipConnectionProfileViewCollectionViewCellReuseIdentifier";

@interface AFBlipConnectionProfileViewCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation AFBlipConnectionProfileViewCollectionView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame collectionViewLayout:[AFBlipConnectionProfileViewCollectionView collectionViewLayout]];
    if(self) {
        
        self.dataSource      = self;
        self.delegate        = self;
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[AFBlipConnectionProfileViewCollectionViewCell class] forCellWithReuseIdentifier:kAFBlipConnectionProfileViewCollectionView_CellReuseIdentifier];
    }
    return self;
}

#pragma mark - UICollectionViewLayout
+ (UICollectionViewFlowLayout *)collectionViewLayout {
    
    //Layout
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing      = 0;
    
    return collectionViewLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_connectionProfileViewDelegate connectionProfileViewCollectionViewNumberOfItems:self] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell
    AFBlipConnectionProfileViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipConnectionProfileViewCollectionView_CellReuseIdentifier forIndexPath:indexPath];
    
    //New timeline cell
    AFBlipVideoTimelineModel *timelineModel;
    
    if(indexPath.row != kAFBlipConnectionProfileViewCollectionView_NewTimelineCellIndex) {
        
        NSUInteger index = indexPath.row - 1;
        timelineModel    = [_connectionProfileViewDelegate connectionProfileViewCollectionView:self itemAtIndex:index];
    }
    
    [cell updateWithTimelineModel:timelineModel];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //New timeline cell
    if(indexPath.row == kAFBlipConnectionProfileViewCollectionView_NewTimelineCellIndex) {
        
        [_connectionProfileViewDelegate connectionProfileViewCollectionViewDidSelectCreateNewTimeline:self];
    } else {
        
        NSUInteger index = indexPath.row - 1;
        [_connectionProfileViewDelegate connectionProfileViewCollectionView:self didSelectTimelineModel:[_connectionProfileViewDelegate connectionProfileViewCollectionView:self itemAtIndex:index]];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell size
    CGFloat cellWidth = (CGRectGetWidth(self.frame) * 0.5f);
    
    return CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if([_connectionProfileViewDelegate respondsToSelector:@selector(connectionProfileViewCollectionViewDidScroll:)]) {
        [_connectionProfileViewDelegate connectionProfileViewCollectionViewDidScroll:self];
    }
}

#pragma mark - Edge insets
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    
    [(UICollectionViewFlowLayout *)self.collectionViewLayout setSectionInset:edgeInsets];
}

- (UIEdgeInsets)edgeInsets {
    
    return [(UICollectionViewFlowLayout *)self.collectionViewLayout sectionInset];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _connectionProfileViewDelegate = nil;
}

@end