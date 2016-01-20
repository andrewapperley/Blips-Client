//
//  AFBlipFilterViewController.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFilterViewController.h"
#import "AFBlipAdditionalFiltersViewController.h"
#import "AFBlipActivityIndicator.h"

NSString *const kAFBlipFilterViewController_FilterVideoPath            = @"blips_temp_video_filter.m4v";
NSString *const kAFBlipFilterViewController_CaptureVideoPath           = @"blips_temp_video_capture.m4v";
NSString *const kAFBlipFilterViewController_VideoThumbnailPath         = @"blips_temp_video_thumbnail_capture.jpg";

@interface AFBlipFilterViewController () <AFBlipFilterViewControllerViewDelegate> {
    NSURL *_captureVideoURLFilePath;
    NSURL *_captureVideoThumbnailURLFilePath;
    AFBlipFilterViewControllerView *_filterView;
    CGSize _videoDimensions;
    AFBlipAdditionalFiltersViewController *_additionalFiltersController;
    AFBlipActivityIndicator *_activityIndicator;
}

@end

@implementation AFBlipFilterViewController

#pragma mark - Init
- (instancetype)initWithDelegate:(id<AFBlipFilterViewControllerDelegate>)delegate videoDimensions:(CGSize)videoSize {
    
    self = [super init];
    if(self) {
        _videoDimensions = CGSizeMake(videoSize.height, videoSize.width);
    }
    
    return self;
}

#pragma mark - Create Filter View

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFilterView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(_filterView.selectedFilterIndex == NSNotFound) {
        [_filterView selectDefaultFilter];
    }
}

- (void)createFilterView {
    _filterView = [[AFBlipFilterViewControllerView alloc] initWithFrame:self.view.bounds delegate:self videoDimensions:_videoDimensions];
    [self.view addSubview:_filterView];
}

#pragma mark Open Filter Purchase Screen
- (void)filterViewOpensFilterPurchaseView:(AFBlipVideoControllerViewPurchaseViewCompletion)completion filterView:(AFBlipFilterViewControllerView *)filterView {
    [self showActivityIndicator:YES];
    typeof(self) __weak wself = self;
    _additionalFiltersController = [[AFBlipAdditionalFiltersViewController alloc] initWithToolbarWithTitle:NSLocalizedString(@"AFBlipAdditionalFiltersTitle", nil) leftButton:NSLocalizedString(@"AFBlipAdditionalFiltersCancelButtonTitle", nil) rightButton:nil loadedBlock:^(AFBlipAdditionalFiltersViewController *controller){
        [wself presentViewController:controller animated:YES completion:^{
            [wself showActivityIndicator:NO];
        }];
    } transactionComplete:^{
        if (completion) {
            completion(YES);
        }
    }];
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    self.view.userInteractionEnabled = !show;
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = CGPointMake(self.view.center.x, self.view.center.y - self.view.frame.origin.y);
        [self.view addSubview:_activityIndicator];
    } else {
        _activityIndicator.alpha            = 1;
    }
    
    if(!show) {
        [_activityIndicator stopAnimating];
        _activityIndicator.alpha            = 0;
    } else {
        [_activityIndicator startAnimating];
    }
}

#pragma mark - Filter Video path string
- (NSURL *)filterVideoPath {
    
    if(_filterVideoURLFilePath) {
        return _filterVideoURLFilePath;
    }
    
    NSString *filterVideoPathString = NSTemporaryDirectory();
    NSURL *filterVideoPath          = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", filterVideoPathString, kAFBlipFilterViewController_FilterVideoPath]];
    
    _filterVideoURLFilePath = filterVideoPath;
    if (!_filterVideoURLFilePath) {
        NSLog( @"Not able to create the directory which contains path %@ : ", filterVideoPath);
    }
    
    return filterVideoPath;
}

#pragma mark - Filter Video path string
- (NSURL *)captureVideoPath {
    
    if(_captureVideoURLFilePath) {
        return _captureVideoURLFilePath;
    }
    
    NSString *captureVideoPathString = NSTemporaryDirectory();
    NSURL *captureVideoPath          = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", captureVideoPathString, kAFBlipFilterViewController_CaptureVideoPath]];
    
    _captureVideoURLFilePath = captureVideoPath;
    if (!_captureVideoURLFilePath) {
        NSLog( @"Not able to create the directory which contains path %@ : ", captureVideoPath);
    }
    
    return captureVideoPath;
}

- (NSURL *)captureVideoThumbnailPath {
    
    if(_captureVideoThumbnailURLFilePath) {
        return _captureVideoThumbnailURLFilePath;
    }
    
    NSString *captureVideoThumbnailPathString = NSTemporaryDirectory();
    NSURL *captureVideoThumbnailPath          = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", captureVideoThumbnailPathString, kAFBlipFilterViewController_VideoThumbnailPath]];
    
    _captureVideoThumbnailURLFilePath = captureVideoThumbnailPath;
    if (!_captureVideoThumbnailURLFilePath) {
        NSLog( @"Not able to create the directory which contains path %@ : ", captureVideoThumbnailPath);
    }
    
    return captureVideoThumbnailPath;
}

#pragma mark - Save video file
- (void)saveFilteredVideoFile:(AFBlipFilterSaveVideoCompletion)completion {
    [_filterView saveVideoFile:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - AFBlipFilterViewControllerViewDelegate methods

- (NSURL *)filterViewFilterVideoFilePath:(AFBlipFilterViewControllerView *)filterView {
    return [self filterVideoPath];
}

- (NSURL *)filterViewCaptureVideoFilePath:(AFBlipFilterViewControllerView *)filterView {
    return [self captureVideoPath];
}

- (NSURL *)filterViewFilterVideoThumbnailFilePath:(AFBlipFilterViewControllerView *)filterView {
    return [self captureVideoThumbnailPath];
}

#pragma mark - Dealloc
- (void)dealloc {
    self.delegate = nil;
}

@end