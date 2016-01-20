//
//  AFBlipConnectionsViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-03-17.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipActivityIndicator.h"
#import "AFBlipConnectionsViewController.h"
#import "AFBlipConnectionsCollectionView.h"
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipConnectionsCollectionViewDatasource.h"
#import "AFBlipConnectionsCollectionViewCell.h"
#import "AFBlipConnectionsPersonalCollectionViewCell.h"
#import "AFBlipSearchBarView.h"
#import "AFBlipConnectionsHeaderCell.h"

const NSInteger kAFBlipCellSearchHeight         = 44;

@interface AFBlipConnectionsViewController () {
    
    AFBlipActivityIndicator *_activityIndicator;
    CGRect _frame;
    AFBlipConnectionsCollectionView* _connectionsCollectionView;
    AFBlipConnectionsCollectionViewDatasource* _connectionsCollectionViewDatasource;
}

@end

@implementation AFBlipConnectionsViewController

#pragma mark - Init
- (instancetype)initWithViewFrame:(CGRect)frame {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _frame  = frame;
        _isOpen = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame            = _frame;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor  = [UIColor clearColor];
    
    _connectionsCollectionView = [[AFBlipConnectionsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _connectionsCollectionView.connectionSectionDelegate = self;
    _connectionsCollectionView.showsVerticalScrollIndicator = NO;
    [_connectionsCollectionView registerClass:[AFBlipConnectionsCollectionViewCell class] forCellWithReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellKey];
    [_connectionsCollectionView registerClass:[AFBlipConnectionsPersonalCollectionViewCell class] forCellWithReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellSection0Key];
    [_connectionsCollectionView registerClass:[AFBlipConnectionsHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellHeaderKey];
    [_connectionsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellSearchKey];

    _connectionsCollectionView.backgroundColor = [UIColor clearColor];
    
    _connectionsCollectionViewDatasource = [[AFBlipConnectionsCollectionViewDatasource alloc] init];
    _connectionsCollectionView.dataSource = _connectionsCollectionView.collectionViewDatasource = _connectionsCollectionViewDatasource;
    
    [self reloadData];
    [self addSearchBar];
    [self.view addSubview:_connectionsCollectionView];
    
}

- (void)addSearchBar {
    AFBlipSearchBarView* searchBar = [[AFBlipSearchBarView alloc] initWithFrame:CGRectMake(0, 0, _connectionsCollectionView.frame.size.width, kAFBlipCellSearchHeight)];
    if (!searchBar.searchBar.delegate) {
        searchBar.searchBar.delegate = _connectionsCollectionView;
    }
    [self.view addSubview:searchBar];
    _connectionsCollectionView.frame = CGRectMake(0, _connectionsCollectionView.frame.origin.y + searchBar.frame.size.height, _connectionsCollectionView.frame.size.width, _connectionsCollectionView.frame.size.height - searchBar.frame.size.height);

}

#pragma mark - AFBlipConnectionsCollectionViewControllerDelegate

- (void)connectionsViewControllerDidSelectConnection:(AFBlipConnectionsCollectionView *)connectionsCollectionView forConnection:(AFBlipConnectionModel *)connection {
    if ([_delegate respondsToSelector:@selector(didSelectConnectionsProfileForConnection:fromController:)]) {
        
        [_delegate didSelectConnectionsProfileForConnection:connection fromController:self];
    }
}

- (void)connectionsViewControllerDidSelectFriendRequest:(AFBlipConnectionsCollectionView *)connectionsCollectionView forConnection:(AFBlipConnectionModel *)connection {
    
    if ([_delegate respondsToSelector:@selector(didSelectConnectionsFriendRequest:fromController:)]) {
        [_delegate didSelectConnectionsFriendRequest:connection fromController:self];
    }
}

- (void)connectionsViewControllerDidSelectSearchResult:(AFBlipConnectionsCollectionView *)connectionsCollectionView forUser:(AFBlipUserModel *)user {
    if ([_delegate respondsToSelector:@selector(didSelectLimitedProfileForUser:toAdd:fromController:)]) {
        [_delegate didSelectLimitedProfileForUser:user toAdd:YES fromController:self ];
    }
}

- (void)connectionsViewControllerDidSelectConnectionForProfile:(AFBlipConnectionsCollectionView *)connectionsCollectionView forUser:(AFBlipUserModel *)user {
    if ([_delegate respondsToSelector:@selector(didSelectLimitedProfileForUser:toAdd:fromController:)]) {
        [_delegate didSelectLimitedProfileForUser:user toAdd:NO fromController:self];
    }
}

- (void)connectionsViewControllerDidSelectPersonalSection:(AFBlipConnectionsCollectionView *)connectionsCollectionView forSection:(kAFBlipConnectionsPersonalSection)section {
    if ([_delegate respondsToSelector:@selector(didSelectPersonalTimelineForSection:fromController:)]) {
        [_delegate didSelectPersonalTimelineForSection:section fromController:self];
    }
}

#pragma mark - Reload data
- (void)reloadData {
    
    typeof(_connectionsCollectionView) __weak weakConnectionCollectionView = _connectionsCollectionView;
    
    if(!_activityIndicator) {
        _activityIndicator = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Small];
        _activityIndicator.center = _connectionsCollectionView.center;
        [_connectionsCollectionView addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    }
    
    typeof(_activityIndicator) __weak weakActivityIndicator = _activityIndicator;
    
    [_connectionsCollectionViewDatasource retrieveConnections:^{
        [weakActivityIndicator stopAnimating];
        [weakConnectionCollectionView reloadData];
    }];
}

#pragma mark - Dealloc
- (void)dealloc {
    _connectionsCollectionViewDatasource = nil;
    _connectionsCollectionView           = nil;
    _delegate                            = nil;
}

@end