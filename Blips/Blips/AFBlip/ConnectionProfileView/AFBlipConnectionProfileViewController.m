//
//  AFBlipConnectionProfileViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-05-11.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionModel.h"
#import "AFBlipConnectionProfileViewController.h"
#import "AFBlipConnectionProfileViewCollectionView.h"
#import "AFBlipConnectionProfileViewProfiles.h"

#import "AFBlipKeychain.h"
#import "AFBlipVideoModelFactory.h"
#import "AFBlipUserModel.h"
#import "AFBlipUserModelSingleton.h"

#pragma mark - Constants
const CGFloat kAFBlipConnectionProfileViewController_ProfileViewHeight = 180.0f;

@interface AFBlipConnectionProfileViewController () <AFBlipConnectionProfileViewCollectionViewDelegate> {
    
    AFBlipConnectionProfileViewCollectionView   *_collectionView;
    AFBlipConnectionProfileViewProfiles         *_profilesView;
    AFBlipConnectionModel                       *_connectionModel;
    NSArray                                     *_timelineModels;
}

@end

@implementation AFBlipConnectionProfileViewController

#pragma mark - Init
- (instancetype)initWithToolbarWithTitle:(NSString *)title leftButton:(NSString *)leftButtonTitle rightButton:(NSString *)rightButtonTitle connectionModel:(AFBlipConnectionModel *)connectionModel {
    
    self = [super initWithToolbarWithTitle:title leftButton:leftButtonTitle rightButton:rightButtonTitle];
    if(self) {
        
        _connectionModel = connectionModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createProfileViews];
    [self createCollectionView];
    [self loadConnectionModelTimelines];
}

- (void)createBackground {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AFBlipBlurredBackgroundPurple"]];
}

- (void)createProfileViews {
    
    AFBlipUserModel *userModel           = [AFBlipUserModelSingleton sharedUserModel].userModel;
    AFBlipUserModel *connectionUserModel = _connectionModel.connectionFriend;

    CGRect frame                         = CGRectMake(0, kAFBlipEditProfileToolbarHeight, CGRectGetWidth(self.view.frame), kAFBlipConnectionProfileViewController_ProfileViewHeight);
    
    _profilesView = [[AFBlipConnectionProfileViewProfiles alloc] initWithFrame:frame userModel:userModel connectionUserModel:connectionUserModel];
    _profilesView.autoresizingMask        = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_profilesView];
}

- (void)createCollectionView {
    
    CGRect frame                        = CGRectMake(0, CGRectGetMinY(_profilesView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kAFBlipEditProfileToolbarHeight);
    UIEdgeInsets edgeInsets             = UIEdgeInsetsMake(CGRectGetHeight(_profilesView.frame), 0, 0, 0);
    
    _collectionView = [[AFBlipConnectionProfileViewCollectionView alloc] initWithFrame:frame];
    _collectionView.connectionProfileViewDelegate = self;
    _collectionView.autoresizingMask              = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _collectionView.edgeInsets                    = edgeInsets;
    _collectionView.backgroundColor               = [UIColor clearColor];
    [self.view addSubview:_collectionView];
}

#pragma mark - Load timelines
- (void)loadConnectionModelTimelines {
    
    AFBlipVideoModelFactory *factory = [[AFBlipVideoModelFactory alloc] init];
    
    NSString *connectionId  = _connectionModel.connectionID;
    NSString *userId        = [AFBlipUserModelSingleton sharedUserModel].userModel.user_id;
    NSString *accessToken   = [AFBlipKeychain keychain].accessToken;
    
    typeof(_collectionView) __weak weakCollectionView  = _collectionView;
    
    [factory fetchAllTimelinesWithConnectionId:connectionId userId:userId accessToken:accessToken success:^(NSArray *timelineIdList, AFBlipBaseNetworkModel *networkCallback) {
        
        _timelineModels = timelineIdList;
        [weakCollectionView reloadData];
        
    } failure:^(NSError *error) {
       
#warning Handle error here
        NSLog(@"Some error here");
    }];
}

#pragma mark - AFBlipConnectionProfileViewControllerDelegate
- (NSUInteger)connectionProfileViewCollectionViewNumberOfItems:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView {
    
    return _timelineModels.count;
}

- (AFBlipVideoTimelineModel *)connectionProfileViewCollectionView:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView itemAtIndex:(NSUInteger)index {
    
    return _timelineModels[index];
}

- (void)connectionProfileViewCollectionView:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView didSelectTimelineModel:(AFBlipVideoTimelineModel *)timelineModel {
    
    [_delegate connectionProfileViewController:self didSelectTimelineModel:timelineModel];
}

- (void)connectionProfileViewCollectionViewDidSelectCreateNewTimeline:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView {
    
    [_delegate connectionProfileViewControllerDidSelectCreateNewTimeline:self];
}

- (void)connectionProfileViewCollectionViewDidScroll:(AFBlipConnectionProfileViewCollectionView *)connectionProfileViewCollectionView {
    
    [_profilesView setProfileViewInternalPosY:connectionProfileViewCollectionView.contentOffset.y];
}

#pragma mark - Toolbar methods
- (void)leftButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end