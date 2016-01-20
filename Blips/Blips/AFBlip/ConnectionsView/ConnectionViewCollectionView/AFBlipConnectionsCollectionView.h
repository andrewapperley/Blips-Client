//
//  AFBlipConnectionsCollectionView.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipConnectionsCollectionViewDatasource.h"

@class AFBlipConnectionsCollectionView, AFBlipConnectionModel, AFBlipUserModel;

@protocol AFBlipConnectionsCollectionViewControllerDelegate <NSObject>

@required
- (void)connectionsViewControllerDidSelectPersonalSection:(AFBlipConnectionsCollectionView *)connectionsCollectionView forSection:(kAFBlipConnectionsPersonalSection)section;
- (void)connectionsViewControllerDidSelectFriendRequest:(AFBlipConnectionsCollectionView *)connectionsCollectionView forConnection:(AFBlipConnectionModel *)connection;
- (void)connectionsViewControllerDidSelectConnection:(AFBlipConnectionsCollectionView *)connectionsCollectionView forConnection:(AFBlipConnectionModel *)connection;
- (void)connectionsViewControllerDidSelectSearchResult:(AFBlipConnectionsCollectionView *)connectionsCollectionView forUser:(AFBlipUserModel *)user;
- (void)connectionsViewControllerDidSelectConnectionForProfile:(AFBlipConnectionsCollectionView *)connectionsCollectionView forUser:(AFBlipUserModel *)user;

@end

@interface AFBlipConnectionsCollectionView : UICollectionView <UISearchBarDelegate>

@property(nonatomic, weak)id <AFBlipConnectionsCollectionViewControllerDelegate> connectionSectionDelegate;
@property(nonatomic, weak)AFBlipConnectionsCollectionViewDatasource* collectionViewDatasource;

@end