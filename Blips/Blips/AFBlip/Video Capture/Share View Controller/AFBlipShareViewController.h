//
//  AFBlipShareViewController.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerBaseViewController.h"

@class AFBlipShareViewController;
@class AFBlipVideoTimelineModel;

@protocol AFBlipShareViewControllerDelegate <NSObject>

@required
- (void)shareViewControllerDidShare:(AFBlipShareViewController *)shareViewController;

@end

typedef void(^AFBlipVideoShareCompletion)(void);

@interface AFBlipShareViewController : AFBlipVideoViewControllerBaseViewController

@property (nonatomic, weak) id<AFBlipShareViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSString *message;

- (instancetype)initWithVideoTimelineModel:(AFBlipVideoTimelineModel *)videoTimelineModel videoContentURL:(NSURL *)videoContentURL videoContentThumbnailURL:(NSURL *)videoContentThumbnailURL message:(NSString *)message;
- (void)share:(AFBlipVideoShareCompletion)completion;

@end