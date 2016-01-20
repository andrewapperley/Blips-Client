//
//  AFBlipFilterVideoPlayer.m
//  Blips
//
//  Created by Andrew Apperley on 2014-08-02.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipFilterVideoPlayer.h"
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFBlipFilterVideoModel.h"
#import "AFBlipFilterListCell.h"
#import "AFBlipActivityIndicator.h"
#import "AFBlipChainFilterDelegate.h"

@interface AFBlipFilterVideoPlayer () <GPUImageMovieWriterDelegate> {
    GPUImageMovie *_movieFile;
    NSString* _selectedFilter;
    GPUImageMovieWriter *_movieWriter;
    UIImage* _thumbnail;
    GPUImageView* _previewView;
    AFBlipActivityIndicator *_activityIndicator;
    CGSize _videoDimensions;
    GPUImageFilterPipeline *_filterPipeline;
}

@end

NSString *const kAFBlipSelectedFilterKey                    = @"kAFBlipSelectedFilterKey";
NSString *const kAFBlipFilterVideoPlayerProduct             = @"afBlipsAdditionalVideoFilters";

@implementation AFBlipFilterVideoPlayer

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<AFBlipFilterVideoPlayerDelegate>)delegate videoDimensions:(CGSize)videoSize {
    
    self = [super initWithFrame:frame];
    if(self) {
        _videoDimensions = videoSize;
        _delegate = delegate;
        [self showActivityIndicator:YES];
        [self generateFilterList];
        [self createBackground];
        [_delegate filterVideoPlayerOutputFilePath:self];
    }
    return self;
}

- (void)createBackground {
    
    self.clipsToBounds   = NO;
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
}

- (void)setupPreviewView {
    _previewView = [[GPUImageView alloc] initWithFrame:self.bounds];
    _previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self addSubview:_previewView];
    [self createVideoPreviewLayerCornersOnLayer:_previewView.layer];
}

- (void)createVideoPreviewLayerCornersOnLayer:(CALayer *)layer {
    NSInteger borderWidth = 3;
    NSInteger borderHeight = 27;
    
    CAShapeLayer *cornerShapes  = [[CAShapeLayer alloc] init];
    cornerShapes.frame          = CGRectMake(self.bounds.origin.x - borderWidth/2, self.bounds.origin.y - borderWidth / 2, self.bounds.size.width + borderWidth, self.bounds.size.height + borderWidth);
    cornerShapes.strokeColor    = [UIColor clearColor].CGColor;
    cornerShapes.fillColor      = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(0, borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, borderHeight)];
    
    [path moveToPoint:CGPointMake(cornerShapes.frame.size.width, borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, 0)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width, borderHeight)];
    
    [path moveToPoint:CGPointMake(cornerShapes.frame.size.width, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.height, cornerShapes.frame.size.height - borderHeight)];
    
    [path moveToPoint:CGPointMake(0, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, cornerShapes.frame.size.height - borderHeight)];
    
    [path closePath];
    
    cornerShapes.path = path.CGPath;
    
    [layer addSublayer:cornerShapes];
}

- (void)setupFilter {
    [self setupMovieFile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseFilterView) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeFilterView) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Set the filter list array

- (void)generateFilterList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *filterListJSON;
    NSMutableArray* filterList = [[NSMutableArray alloc] init];
    BOOL _boughtFilters = NO;
    
    for (NSDictionary *reciept in [[NSUserDefaults standardUserDefaults] arrayForKey:@"blipsUserReceipts"]) {
        if ([reciept[@"receipt_product_id"] isEqualToString:kAFBlipFilterVideoPlayerProduct]) {
            _boughtFilters = YES;
            break;
        }
    }
    
    /*Home Directory filter list, this is a copy of the downloaded version after the user purchases an add-on pack*/
    NSString *downloadedJSONList = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AFBlipVideoFilterExtraList.json"];

    /*Check if they downloaded the file*/
    if (![fileManager fileExistsAtPath:downloadedJSONList] || !_boughtFilters) {
        filterListJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AFBlipVideoFilterDefaultList" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
    } else {
        filterListJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:downloadedJSONList] options:NSJSONReadingMutableContainers error:nil];
    }
    
    for (NSDictionary* filter in filterListJSON[@"filter_list"]) {
        [filterList addObject:[AFBlipFilterVideoModel filterModelWithClassName:filter[@"filter_class"] title:filter[@"filter_title"] image:filter[@"filter_image"]]];
    }
    
    /*Grab the array of filters from the dictionary and assign them to the filter list var*/
    _filterList = (NSArray *)filterList;
}

- (void)refreshFilterList {
    [self generateFilterList];
}

#pragma mark - Setup Movie File

- (void)setupMovieFile {
    _movieFile = [[GPUImageMovie alloc] initWithURL:[_delegate videoPlayerOutputFilePath:self]];
    _movieFile.shouldRepeat = YES;
    _movieFile.playAtActualSpeed = YES;
}

#pragma mark - Save Video After Processing

- (void)setupMovieWriter {
    if (!_movieWriter) {
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[_delegate filterVideoPlayerOutputFilePath:self] size:_videoDimensions fileType:AVFileTypeQuickTimeMovie outputSettings:@{
                                                                                                                                                                                         AVVideoCodecKey: AVVideoCodecH264,
                                                                                                                                                                                         AVVideoWidthKey: @(self.bounds.size.width*2),
                                                                                                                                                                                         AVVideoHeightKey: @(self.bounds.size.height*2),
                                                                                                                                                                                         AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                                                                                                                                                                         AVVideoCompressionPropertiesKey: @{AVVideoAverageBitRateKey: @(700000)}
                                                                                                                                                                                         }];
        _movieWriter.shouldPassthroughAudio = YES;
        _movieFile.audioEncodingTarget = _movieWriter;
        [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
        [_movieWriter setInputSize:_videoDimensions atIndex:0];
    }
}

- (void)cleanupFilterVideo {
    unlink([[_delegate filterVideoPlayerOutputFilePath:self].path UTF8String]);
    unlink([[_delegate filterVideoPlayerThumbnailOutputFilePath:self].path UTF8String]);
}

#define degreesToRadian(x)  (M_PI * (x) / 180.0)

- (void)saveVideoFile:(AFBlipFilterSaveVideoCompletion)completion {
    [self showActivityIndicator:YES];
    [_movieFile cancelProcessing];
    if (_movieWriter) {
        [_movieWriter endProcessing];
    }
    [self cleanupFilterVideo];
    
    [self setupMovieWriter];
    
    __block typeof(_thumbnail) weakThumbnail = _thumbnail;
    __weak typeof(self) weakSelf = self;
    __block typeof(completion) weakCompletion = completion;
    typeof(_filterPipeline) __weak wFilterPipeline = _filterPipeline;
    [_movieWriter setCompletionBlock:^{
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            /*Rotate Image because all images come out on their side*/
            /*Crop Image to size of video player*/
            CGImageRef croppedImageRef = CGImageCreateWithImageInRect(weakThumbnail.CGImage, CGRectMake(0, 0, weakThumbnail.size.height, weakThumbnail.size.width));
            weakThumbnail = [UIImage imageWithCGImage:croppedImageRef scale:weakThumbnail.scale orientation:UIImageOrientationRight];
            CGImageRelease(croppedImageRef);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSURL *thumbnailURL = [weakSelf.delegate filterVideoPlayerThumbnailOutputFilePath:weakSelf];
                
                NSData *thumbnailData = UIImageJPEGRepresentation(weakThumbnail, 1);
                
                [thumbnailData writeToURL:thumbnailURL atomically:YES];
                
                if (weakCompletion) {
                    weakCompletion();
                    [weakSelf showActivityIndicator:NO];
                }
                
                [weakSelf cleanupVideoFilter];
                
            });
        });
    }];
    
    [_movieWriter setFailureBlock:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        if (weakCompletion) {
            weakCompletion();
            [weakSelf showActivityIndicator:NO];
        }
        [weakSelf cleanupVideoFilter];
    }];
    
    
    [_movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(degreesToRadian(90))];
    [self applyFilter:_selectedFilter toPreview:_previewView];
    
    do {
        [[[wFilterPipeline filters] lastObject] useNextFrameForImageCapture];
        weakThumbnail = [[[wFilterPipeline filters] lastObject] imageFromCurrentFramebuffer];
    } while (!weakThumbnail);
}

#pragma mark - Resume/Pause Filter Processing

- (void)pauseFilterView {
    [_movieFile endProcessing];
}

- (void)resumeFilterView {
    [_movieFile startProcessing];
}

- (void)applyFilterForFilterIndex:(NSInteger)index {
    [self showActivityIndicator:YES];
    [self applyFilter:[_filterList[index] filterClass] toPreview:_previewView];
    [self showActivityIndicator:NO];
}

static BOOL _applyingFilter = NO;

- (void)applyFilter:(__weak NSString *)newFilter toPreview:(__weak GPUImageView *)previewView {
    
    if(!_previewView) {
        [self setupPreviewView];
        [self setupFilter];
        previewView = _previewView;
    }
    
    if (!_filterPipeline) {
        _filterPipeline = [[GPUImageFilterPipeline alloc] init];
        [_filterPipeline setInput:_movieFile];
    }
    
    if (!_applyingFilter) {
        _applyingFilter = YES;
        [[NSUserDefaults standardUserDefaults] setObject:(!_selectedFilter) ? newFilter : _selectedFilter forKey:kAFBlipSelectedFilterKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _selectedFilter = newFilter;
        
        /*Make the class from the filterName*/
        __weak Class filterClassFromNewFilterString = NSClassFromString(newFilter);
        
        /*Stop current processing to speed up filter switching*/
        [_movieFile cancelProcessing];
        
        for (GPUImageFilter *filter in _filterPipeline.filters) {
            [filter removeAllTargets];
        }
        
        [_movieFile removeAllTargets];
        
        /*Create the new filter from the newFilter name*/
        GPUImageFilter *_filter = [[filterClassFromNewFilterString alloc] init];
        [_filter forceProcessingAtSizeRespectingAspectRatio:CGSizeMake(self.bounds.size.width*2, self.bounds.size.height*2)];
        
        id<GPUImageInput> output;
        
        /*Add the filter and movieFile together then start processing again*/
        if (_movieWriter) {
            output = _movieWriter;
        } else {
            /*Rotate the Preview screens input because the filters are on the side always :s*/
            output = previewView;
        }
        
        [_filterPipeline setOutput:output];
        
        NSMutableArray *filterChain;
        
        /*Chain additional filters if the filter requires them*/
        if ([_filter respondsToSelector:@selector(chainFilters)]) {
            NSMutableArray *chain = [NSMutableArray arrayWithArray:[(id<AFBlipChainFilterDelegate>)_filter chainFilters]];
            [chain addObject:_filter];
            filterChain = chain;
            
        } else {
            filterChain = [NSMutableArray arrayWithObject:_filter];
        }
        
        [_filterPipeline replaceAllFilters:filterChain];

        for (NSInteger i = 0; i < filterChain.count; i++) {
            [previewView setInputRotation:kGPUImageRotateRight atIndex:i];
        }
        
        [_movieFile startProcessing];
        
        _applyingFilter = NO;
    }
    
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _filterList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AFBlipFilterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFBlipFilterCellKey forIndexPath:indexPath];
    AFBlipFilterVideoModel *model = _filterList[indexPath.row];
    [cell updateFilterCellWithTitle:model.filterTitle image:model.filterImage class:model.filterClass];
    return cell;
}

#pragma mark - Activity indicator
- (void)showActivityIndicator:(BOOL)show {
    
    if(!_activityIndicator && show) {
        
        _activityIndicator                  = [[AFBlipActivityIndicator alloc] initWithStyle:AFBlipActivityIndicatorType_Large];
        _activityIndicator.alpha            = 0;
        _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _activityIndicator.center           = self.center;
        [self addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
    } else if(show) {
        [_activityIndicator startAnimating];
    }
    
    [self bringSubviewToFront:_activityIndicator];
    
    if(!show) {
        [_activityIndicator stopAnimating];
    }
}

#pragma mark - cleanup

- (void)dealloc {
    [self cleanupVideoFilter];
}

- (void)cleanupVideoFilter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _movieWriter.delegate = nil;
    [_movieFile endProcessing];
    _movieFile.delegate = nil;
    
    
    for (GPUImageFilter *filter in _filterPipeline.filters) {
        if ([filter respondsToSelector:@selector(cleanupFilter)]) {
            [(id<AFBlipChainFilterDelegate>)filter cleanupFilter];
        }
        [filter removeAllTargets];
    }
    
    
    [_movieFile removeAllTargets];
    
    [_movieWriter finishRecording];

    [_filterPipeline removeAllFilters];
    
    _previewView = nil;
    _movieFile = nil;
    _movieWriter = nil;
    _filterList = nil;
    _delegate = nil;
    _filterPipeline = nil;
}

@end