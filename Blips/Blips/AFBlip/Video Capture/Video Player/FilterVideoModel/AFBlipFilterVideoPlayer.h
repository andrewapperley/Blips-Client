//
//  AFBlipFilterVideoPlayer.h
//  Blips
//
//  Created by Andrew Apperley on 2014-08-02.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AFBlipFilterSaveVideoCompletion)(void);

@class AFBlipFilterVideoPlayer;

@protocol AFBlipFilterVideoPlayerDelegate <NSObject>

@required
- (NSURL *)filterVideoPlayerOutputFilePath:(AFBlipFilterVideoPlayer *)filterVideoPlayer;
- (NSURL *)filterVideoPlayerThumbnailOutputFilePath:(AFBlipFilterVideoPlayer *)filterVideoPlayer;
- (NSURL *)videoPlayerOutputFilePath:(AFBlipFilterVideoPlayer *)filterVideoPlayer;

@end

extern NSString *const kAFBlipSelectedFilterKey;

@interface AFBlipFilterVideoPlayer : UIView <UICollectionViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AFBlipFilterVideoPlayerDelegate>)delegate videoDimensions:(CGSize)videoSize;
- (void)saveVideoFile:(AFBlipFilterSaveVideoCompletion)completion;
- (void)applyFilterForFilterIndex:(NSInteger)index;
- (void)refreshFilterList;

@property(nonatomic, weak)id<AFBlipFilterVideoPlayerDelegate> delegate;
@property(nonatomic, strong, readonly)NSArray *filterList;

@end