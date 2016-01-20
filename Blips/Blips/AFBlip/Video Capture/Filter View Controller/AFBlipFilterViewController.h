//
//  AFBlipFilterViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerBaseViewController.h"
#import "AFBlipFilterViewControllerView.h"

@class AFBlipFilterViewController;

@protocol AFBlipFilterViewControllerDelegate <NSObject>
- (void)saveFilteredVideoFile:(AFBlipFilterViewController *)filterViewController filteredVideoURL:(NSURL *)filteredURL completion:(AFBlipFilterSaveVideoCompletion)completion;
@required

@end

@interface AFBlipFilterViewController : AFBlipVideoViewControllerBaseViewController

@property (nonatomic, weak) id<AFBlipFilterViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly)NSURL *filterVideoURLFilePath;

- (instancetype)initWithDelegate:(id<AFBlipFilterViewControllerDelegate>)delegate videoDimensions:(CGSize)videoSize;
- (void)saveFilteredVideoFile:(AFBlipFilterSaveVideoCompletion)completion;
@end