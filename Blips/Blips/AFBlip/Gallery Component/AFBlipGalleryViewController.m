//
//  AFBlipGalleryViewController.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-22.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipGalleryViewController.h"
#import "AFBlipGalleryCollectionViewCell.h"
#import "UIColor+AFBlipColor.h"

NSString * const kAFBlipGalleryCellKey = @"kAFBlipGalleryCellKey";

@interface AFBlipGalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate> {
    NSArray *_objects;
    UICollectionView *_galleryCollectionView;
    UIPageControl *_pagingDots;
    CGRect _frame;
}

@end

@implementation AFBlipGalleryViewController

- (instancetype)initWithGalleryObjects:(NSArray *)objects frame:(CGRect)frame {
    if (self = [super init]) {
        _objects = objects;
        _frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = _frame;
    [self setupCollectionView];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:_frame.size];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    _galleryCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _galleryCollectionView.delegate = self;
    _galleryCollectionView.dataSource = self;
    _galleryCollectionView.backgroundColor = [UIColor clearColor];
    [_galleryCollectionView registerClass:[AFBlipGalleryCollectionViewCell class] forCellWithReuseIdentifier:kAFBlipGalleryCellKey];
    [_galleryCollectionView setPagingEnabled:YES];
    [_galleryCollectionView setShowsHorizontalScrollIndicator:NO];
    [_galleryCollectionView setBouncesZoom:NO];
    [self.view addSubview:_galleryCollectionView];
    
    
    UIView *pagingDotsBG = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_galleryCollectionView.frame), _frame.size.width, 20)];
    pagingDotsBG.backgroundColor = [UIColor clearColor];
    _pagingDots = [[UIPageControl alloc] init];
    _pagingDots.pageIndicatorTintColor        = [UIColor whiteColor];
    _pagingDots.currentPageIndicatorTintColor = [UIColor afBlipOrangeSecondaryColor];
    _pagingDots.userInteractionEnabled = NO;
    [_pagingDots setNumberOfPages:_objects.count];
    _pagingDots.frame = CGRectMake((_frame.size.width - [_pagingDots sizeForNumberOfPages:_pagingDots.numberOfPages].width)/2, 0, [_pagingDots sizeForNumberOfPages:_pagingDots.numberOfPages].width, pagingDotsBG.frame.size.height);
    [self.view addSubview:pagingDotsBG];
    [pagingDotsBG addSubview:_pagingDots];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self scrollViewDidEndDecelerating:_galleryCollectionView];
    [super viewDidAppear:animated];
}

#pragma mark Collectionview Datasource/Delegate/Scrollview methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger scrollViewOffset = scrollView.contentOffset.x;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollViewOffset/self.view.bounds.size.width inSection:0];
    [_pagingDots setCurrentPage:indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for(AFBlipGalleryCollectionViewCell *cell in _galleryCollectionView.visibleCells) {
        
        CGFloat positionX = [self parallaxPositionForCell:cell];
        [cell updatePositionX:positionX];
    }
}

- (CGFloat)parallaxPositionForCell:(UICollectionViewCell *)cell {
    
    static CGFloat minPos;
    static CGFloat maxPos;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        minPos = -1.0f;
        maxPos = 1.0f;
        
    });
    CGRect frame = cell.frame;
    const CGPoint point = [[cell superview] convertPoint:frame.origin toView:_galleryCollectionView];
    
    const CGFloat minX = CGRectGetMinX(_galleryCollectionView.bounds) - CGRectGetWidth(frame);
    const CGFloat maxX = CGRectGetMaxX(_galleryCollectionView.bounds);
    
    return (maxPos - minPos) / (maxX - minX) * (point.x - minX) + minPos;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objects.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFBlipGalleryCollectionViewCell *cell = (AFBlipGalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipGalleryCellKey forIndexPath:indexPath];
    [cell updateCellWithObject:_objects[indexPath.row]];
    [cell updateUIAfterFontSizeChange];
    return cell;
}

- (void)dealloc {
    _objects = nil;
    _galleryCollectionView.delegate = nil;
    _galleryCollectionView.dataSource = nil;
}

@end
