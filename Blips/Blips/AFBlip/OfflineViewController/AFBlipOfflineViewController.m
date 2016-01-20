//
//  AFBlipOfflineViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-08-31.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipOfflineViewController.h"
#import "AFBlipOfflineViewControllerView.h"
#import <AFNetworkReachabilityManager.h>

@implementation AFBlipOfflineViewController

#pragma mark - Init
- (instancetype)init {
    
    self = [super init];
    if(self) {
        [self createNotifications];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createOfflineView];
}

- (void)createNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStatusDidChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)createOfflineView {
    
    AFBlipOfflineViewControllerView *view = [[AFBlipOfflineViewControllerView alloc] initWithFrame:self.view.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:view];
}

- (void)connectionStatusDidChange {
    
    if(![AFNetworkReachabilityManager sharedManager].reachable) {
        return;
    }
    
    [_delegate offlineViewControllerDidReconnect:self];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _delegate = nil;
}

@end