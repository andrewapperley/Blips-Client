//
//  AFBlipFilterViewControllerView.h
//  Blips
//
//  Created by Andrew Apperley on 2014-08-02.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFBlipVideoViewControllerMediatorStatics.h"
#import "AFBlipFilterVideoPlayer.h"

typedef void(^AFBlipVideoControllerViewPurchaseViewCompletion)(BOOL success);

@class AFBlipFilterViewControllerView, AFBlipFilterVideoPlayer;

@protocol AFBlipFilterViewControllerViewDelegate <NSObject>
@required
- (NSURL *)filterViewCaptureVideoFilePath:(AFBlipFilterViewControllerView *)filterView;
- (NSURL *)filterViewFilterVideoFilePath:(AFBlipFilterViewControllerView *)filterView;
- (NSURL *)filterViewFilterVideoThumbnailFilePath:(AFBlipFilterViewControllerView *)filterView;
- (void)filterViewOpensFilterPurchaseView:(AFBlipVideoControllerViewPurchaseViewCompletion)completion filterView:(AFBlipFilterViewControllerView *)filterView;
@end

@interface AFBlipFilterViewControllerView : UIView

@property (nonatomic, assign, readonly) NSInteger selectedFilterIndex;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AFBlipFilterViewControllerViewDelegate>)delegate videoDimensions:(CGSize)videoSize;
- (void)saveVideoFile:(AFBlipFilterSaveVideoCompletion)completion;
- (void)selectDefaultFilter;

@property(nonatomic, weak)id<AFBlipFilterViewControllerViewDelegate> delegate;

@end