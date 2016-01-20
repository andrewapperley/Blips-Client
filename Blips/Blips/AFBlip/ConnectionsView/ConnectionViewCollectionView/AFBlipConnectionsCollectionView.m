//
//  AFBlipConnectionsCollectionView.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipUserModel.h"
#import "AFBlipConnectionModel.h"
#import "AFBlipActivityIndicator.h"
#import "AFBlipConnectionsCollectionView.h"
#import "AFBlipConnectionsViewControllerStatics.h"
#import "AFBlipConnectionsPersonalCollectionViewCell.h"

const NSInteger kAFBlipCellHeaderHeight = 25;
const NSTimeInterval kAFBlipConnectionsCollectionView_insetAnimationDuration = 0.25f;

@interface AFBlipConnectionsCollectionView() <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIGestureRecognizerDelegate> {
    AFBlipActivityIndicator *_activityIndicator;
    BOOL _searchBarWantsFocus;
    BOOL _blockSearching;
    NSInteger _previousSearchLength;
    UITapGestureRecognizer* _tapGesture;
    UILongPressGestureRecognizer *_longPressGesture;
    __weak UISearchBar* _searchbar;
    BOOL _scrollBlocker;
}

@end

@implementation AFBlipConnectionsCollectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame collectionViewLayout:[AFBlipConnectionsCollectionView collectionViewLayout]];
    if (self) {
        self.delegate = self;
        _searchBarWantsFocus = YES;
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        _longPressGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_longPressGesture];
        self.delaysContentTouches = NO;
    }
    return self;
}

#pragma mark - UICollectionViewDelegateFlowLayout

+ (UICollectionViewFlowLayout *)collectionViewLayout {
    
    UICollectionViewFlowLayout *collectionViewLayout    = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.minimumInteritemSpacing        = 0;
    collectionViewLayout.minimumLineSpacing             = 0;
    
    return collectionViewLayout;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = CGSizeMake(CGRectGetWidth(collectionView.frame) / 2, CGRectGetWidth(collectionView.frame) / 2);

    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize headerSize = CGSizeMake(CGRectGetWidth(collectionView.frame) / 2, kAFBlipCellHeaderHeight);
    
    switch(section) {
        case kAFBlipConnectionsListSections_PersonalSection:
            headerSize.height = 0.0f;
            break;
        case kAFBlipConnectionsListSections_PendingRequestsSection:
            if(_collectionViewDatasource.pendingRequests.count <= 0) {
                headerSize.height = 0.0f;
            }
            break;
        case kAFBlipConnectionsListSections_ConnectionsSection:
            if(_collectionViewDatasource.connections.count <= 0) {
                headerSize.height = 0.0f;
            }
            break;
        case kAFBlipConnectionsListSections_SearchSection:
            if(!_searchbar || !_searchbar.isFirstResponder) {
                headerSize.height = 0.0f;
            }
            break;
        default:
            break;
    }
    
    return headerSize;
}

#pragma mark - UILongPressGesture Methods
- (void)onLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *_longPressIndexPath = [self indexPathForItemAtPoint:[gesture locationOfTouch:0 inView:self]];
        
        if (_longPressIndexPath.section == kAFBlipConnectionsListSections_ConnectionsSection) {
            if ([_connectionSectionDelegate respondsToSelector:@selector(connectionsViewControllerDidSelectConnectionForProfile:forUser:)]) {
                [_connectionSectionDelegate connectionsViewControllerDidSelectConnectionForProfile:self forUser:[self.collectionViewDatasource.connections[_longPressIndexPath.row] connectionFriend]];
            }
        }
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    switch (indexPath.section) {
        case kAFBlipConnectionsListSections_PersonalSection:
            if ([_connectionSectionDelegate respondsToSelector:@selector(connectionsViewControllerDidSelectPersonalSection:forSection:)]) {
                [_connectionSectionDelegate connectionsViewControllerDidSelectPersonalSection:self forSection:((AFBlipConnectionsPersonalModel *)self.collectionViewDatasource.personalSections[indexPath.row]).section];
            }
            
            break;
            
        case kAFBlipConnectionsListSections_PendingRequestsSection:
            if ([_connectionSectionDelegate respondsToSelector:@selector(connectionsViewControllerDidSelectFriendRequest:forConnection:)]) {
                [_connectionSectionDelegate connectionsViewControllerDidSelectFriendRequest:self forConnection:self.collectionViewDatasource.pendingRequests[indexPath.row]];
            }
            
            break;
            
        case kAFBlipConnectionsListSections_ConnectionsSection:
            if ([_connectionSectionDelegate respondsToSelector:@selector(connectionsViewControllerDidSelectConnection:forConnection:)]) {
                
                AFBlipConnectionModel *connectionModel = self.collectionViewDatasource.connections[indexPath.row];
                [_connectionSectionDelegate connectionsViewControllerDidSelectConnection:self forConnection:connectionModel];
                
                connectionModel.connectionFriend.videoCount = 0;
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            
            break;
            
        case kAFBlipConnectionsListSections_SearchSection:
            if ([_connectionSectionDelegate respondsToSelector:@selector(connectionsViewControllerDidSelectSearchResult:forUser:)]) {
                [_connectionSectionDelegate connectionsViewControllerDidSelectSearchResult:self forUser:self.collectionViewDatasource.searchResults[indexPath.row]];
            }
            
            break;
    }
       
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(!_activityIndicator) {
        _activityIndicator = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Small];
        _activityIndicator.center = self.center;
        [self addSubview:_activityIndicator];
    }
    
    [_activityIndicator startAnimating];
    
    if (_blockSearching && (_previousSearchLength == searchText.length)) {
        return;
    }
    
    _previousSearchLength = searchText.length;

    typeof(self) __weak weakSelf = self;
    typeof(_activityIndicator) __weak weakActivityIndicator = _activityIndicator;

    if ([searchText isEqualToString:@""]) {
        [_collectionViewDatasource updateConnectionsListAfterSearchingWithCompletion:^{
            [weakActivityIndicator stopAnimating];
            [weakSelf reloadData];
        }];
        if(![searchBar isFirstResponder]) {
            _searchBarWantsFocus = NO;
            _scrollBlocker = YES;
            [self showPersonalSections];
        }
        return;
    }
    
    [_collectionViewDatasource searchWithSearchQuery:searchText withCompletion:^{
        [weakActivityIndicator stopAnimating];
        [weakSelf reloadData];
        _blockSearching = (_collectionViewDatasource.searchResults.count == 0);
    }];
    
    if(searchText.length > 0) {
        [self hidePersonalSections];
    } else {
        [self showPersonalSections];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    
    if ((!_tapGesture)) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        _tapGesture.numberOfTapsRequired = 1;
    }
    _searchbar = bar;
    [self addGestureRecognizer:_tapGesture];
    
    if (!_scrollBlocker) {
        
        [UIView animateWithDuration:kAFBlipConnectionsCollectionView_insetAnimationDuration animations:^{
            [self setContentInset:UIEdgeInsetsMake( - CGRectGetWidth(self.frame) / 2, 0, 0, 0)];
        }];
    }
    
    BOOL boolToReturn = _searchBarWantsFocus;
    _searchBarWantsFocus = YES;
    _scrollBlocker = NO;
    return boolToReturn;
}

- (void)dismissKeyboard:(UIGestureRecognizer *)gesture {
    [_searchbar resignFirstResponder];
    [self removeGestureRecognizer:gesture];
    
    if(_collectionViewDatasource.searchResults.count > 0) {
        [self hidePersonalSections];
    } else {
        [self showPersonalSections];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self removeGestureRecognizer:_tapGesture];
    
    if(_collectionViewDatasource.searchResults.count > 0) {
        [self hidePersonalSections];
    } else {
        [self showPersonalSections];
    }
}

- (void)showPersonalSections {
    [UIView animateWithDuration:kAFBlipConnectionsCollectionView_insetAnimationDuration animations:^{
        [self setContentInset:UIEdgeInsetsZero];
    }];
}

- (void)hidePersonalSections {
    [UIView animateWithDuration:kAFBlipConnectionsCollectionView_insetAnimationDuration animations:^{
        [self setContentInset:UIEdgeInsetsMake( - CGRectGetWidth(self.frame) / 2, 0, 0, 0)];

    }];
}

- (void)dealloc {
    self.delegate               = nil;
    _collectionViewDatasource   = nil;
    _connectionSectionDelegate  = nil;
    [self removeGestureRecognizer:_tapGesture];
    [self removeGestureRecognizer:_longPressGesture];
}

@end