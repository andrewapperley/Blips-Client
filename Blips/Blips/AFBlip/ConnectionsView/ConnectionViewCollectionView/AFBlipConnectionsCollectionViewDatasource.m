//
//  AFBlipConnectionsCollectionViewDatasource.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionsCollectionViewDatasource.h"
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipConnectionModelFactory.h"
#import "AFBlipConnectionsCollectionViewCell.h"
#import "AFBlipConnectionsPersonalCollectionViewCell.h"
#import "AFBlipMainViewControllerStatics.h"
#import "AFBlipSearchBarView.h"
#import "AFBlipConnectionsHeaderCell.h"
#import "AFBlipUserModelFactory.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipKeychain.h"

@class AFBlipConnectionsCollectionView;

@interface AFBlipConnectionsCollectionViewDatasource() {
    NSArray* _savedConnections;
    NSArray* _savedPendingRequests;
    AFBlipUserModelFactory* _userModelFactory;
}

@end

@implementation AFBlipConnectionsCollectionViewDatasource

- (id)init {
    if (self = [super init]) {
        _userModelFactory = [[AFBlipUserModelFactory alloc] init];
        [self createPersonalSectionModels];
    }
    return self;
}

- (void)retrieveConnections:(AFBlipConnectionsDatasourceCompletion)completion {
    
    AFBlipUserModel *userModel                 = [AFBlipUserModelSingleton sharedUserModel].userModel;
    AFBlipConnectionModelFactory* modelFactory = [[AFBlipConnectionModelFactory alloc] init];
    [modelFactory connectionListWithUserID:userModel.user_id accessToken:[AFBlipKeychain keychain].accessToken success:^(AFBlipBaseNetworkModel *networkCallback, NSArray *connections, NSArray *pendingRequests) {
        
        _connections = _savedConnections = connections;
        _pendingRequests = _savedPendingRequests = pendingRequests;
        
        completion();
    } failure:^(NSError *error) {
        
    }];
}

- (void)createPersonalSectionModels {
    _personalSections = @[[AFBlipConnectionsPersonalModel createPersonalModelWithSectionName:NSLocalizedString(@"AFBlipConnectionsRecentBlips" , nil) sectionImage:[UIImage imageNamed:@"AFBlipRecentBlipsIcon"] section:kAFBlipConnectionsPersonalSection_Recent],
                          [AFBlipConnectionsPersonalModel createPersonalModelWithSectionName:NSLocalizedString(@"AFBlipConnectionsFavouriteBlips" , nil) sectionImage:[UIImage imageNamed:@"AFBlipFavouriteBlipsIcon"] section:kAFBlipConnectionsPersonalSection_Favourites]];
}

- (void)updateConnectionsListAfterSearchingWithCompletion:(AFBlipConnectionsDatasourceCompletion)completion {
    _searchResults = nil;
    _connections = _savedConnections;
    _pendingRequests = _savedPendingRequests;
    completion();
}

- (void)searchWithSearchQuery:(NSString *)searchQuery withCompletion:(AFBlipConnectionsDatasourceCompletion)completion {
    
    NSPredicate* searchPredicate = [NSPredicate predicateWithFormat:@"connectionFriend.displayName like[cd] %@", [searchQuery stringByAppendingString:@"*"]];
    _connections = [_savedConnections filteredArrayUsingPredicate:searchPredicate];
    _pendingRequests = [_savedPendingRequests filteredArrayUsingPredicate:searchPredicate];
    
    AFBlipUserModel *userModel   = [AFBlipUserModelSingleton sharedUserModel].userModel;
    [_userModelFactory fetchUsersBySearchingWithSearchTerm:searchQuery userID:userModel.user_id accessToken:[AFBlipKeychain keychain].accessToken success:^(NSArray *searchResults, AFBlipBaseNetworkModel *networkCallback) {
        _searchResults = searchResults;
        if (completion) {
            completion();
        }
    } failure:^(NSError *error) {
        _searchResults = nil;
        if (completion) {
            completion();
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case kAFBlipConnectionsListSections_PersonalSection:
            return _personalSections.count;
            break;
            
        case kAFBlipConnectionsListSections_PendingRequestsSection:
            return _pendingRequests.count;
            break;
            
        case kAFBlipConnectionsListSections_ConnectionsSection:
            return _connections.count;
            break;
            
        case kAFBlipConnectionsListSections_SearchSection:
            return _searchResults.count;
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kAFBlipConnectionsListSections_Count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(kind != UICollectionElementKindSectionHeader) {
        return nil;
    }
    
    if (indexPath.section == kAFBlipConnectionsListSections_PersonalSection) {
        UICollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellSearchKey forIndexPath:indexPath];        
        return header;
    }
    
    
    AFBlipConnectionsHeaderCell* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellHeaderKey forIndexPath:indexPath];
    
    switch (indexPath.section) {
            
        case kAFBlipConnectionsListSections_PendingRequestsSection:
            [header setHeaderText:NSLocalizedString(@"AFBlipConnectionsConnectionsRequests" , nil)];
            return header;
            break;
            
        case kAFBlipConnectionsListSections_ConnectionsSection:
            [header setHeaderText:NSLocalizedString(@"AFBlipConnectionsConnectionsBlips" , nil)];
            return header;
            break;
            
        case kAFBlipConnectionsListSections_SearchSection:
            header.alpha = !(_searchResults.count == 0);
            [header setHeaderText:NSLocalizedString(@"AFBlipConnectionsSearchResultsBlips" , nil)];
            return header;
            break;
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case kAFBlipConnectionsListSections_PersonalSection: {
            AFBlipConnectionsPersonalCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellSection0Key forIndexPath:indexPath];
            [cell createPersonalCellWithModel:_personalSections[indexPath.row]];
            return cell;
            break;
        }
            
        case kAFBlipConnectionsListSections_PendingRequestsSection: {
            AFBlipConnectionsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellKey forIndexPath:indexPath];
            AFBlipConnectionModel *connectionModel = _pendingRequests[indexPath.row];
            [cell createConnection:connectionModel];
            [cell updateUsersNotifications:1 badgeType:AFBlipNotificationBadgeType_FriendRequest];
            return cell;
            break;
        }
            
        case kAFBlipConnectionsListSections_ConnectionsSection: {
            AFBlipConnectionsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellKey forIndexPath:indexPath];
            AFBlipConnectionModel *connectionModel = _connections[indexPath.row];
            [cell createConnection:connectionModel];
            
            //Video count badge will take priority over newly added friend badge
            NSUInteger videoCount = connectionModel.connectionFriend.videoCount;
            
            //Video badge
            if(videoCount > 0) {
                [cell updateUsersNotifications:videoCount badgeType:AFBlipNotificationBadgeType_Connection];
            //Newly added friend badge
            } else if(connectionModel.connectionFriend.isNewConnection){
                videoCount = 1;
                [cell updateUsersNotifications:videoCount badgeType:AFBlipNotificationBadgeType_NewlyAddedFriend];
            }

            return cell;
            break;
        }
            
        case kAFBlipConnectionsListSections_SearchSection: {
            AFBlipConnectionsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipConnectionsViewControllerStatics_CollectionViewCellKey forIndexPath:indexPath];
            [cell createSearchResult:_searchResults[indexPath.row]];
            return cell;
            break;
        }
    }
    return nil;
}

@end