//
//  AFBlipVideoModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipDateFormatter.h"
#import "AFBlipVideoModelDatasource.h"
#import "AFBlipVideoModelFactory.h"

@implementation AFBlipVideoModelFactory

#pragma mark - Post video creation
- (void)postVideoModelWithUserId:(NSString *)userId timelineId:(NSString *)timelineId videoContent:(NSData *)videoContent date:(long)date accessToken:(NSString *)accessToken videoThumbnail:(NSData *)videoThumbnail andVideoDescription:(NSString *)description success:(AFBlipVideoCreationModelSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postCreateVideoModelWithUserId:userId timelineId:timelineId videoContent:videoContent date:date accessToken:accessToken videoThumbnail:videoThumbnail videoDescription:description success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Videos at page index
- (void)videosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken timelineIds:(NSArray *)timelineIds singleUserConnectionOnly:(BOOL)singleUserConnectionOnly success:(AFBlipVideoList)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource fetchVideosAtPageIndex:pageIndex userId:userId accessToken:accessToken timelineIds:timelineIds singleUserConnectionOnly:singleUserConnectionOnly success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AFBlipVideoTimelineModel *model;
            
            if(networkCallback.success) {
                model = [AFBlipVideoModelFactory videoPlaylistModelForData:networkCallback.responseData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(model, networkCallback);
            });
        });
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Timeline fetch
- (void)fetchAllTimelinesForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipTimelineIdList)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource fetchAllTimelinesForUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *timelineList;
            
            if(networkCallback.success) {
                timelineList = [AFBlipVideoModelFactory timelineListForData:networkCallback.responseData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(timelineList, networkCallback);
            });
        });
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Timeline list fetch by connection id
- (void)fetchAllTimelinesWithConnectionId:(NSString *)connectionId userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipTimelineList)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource fetchAllTimelinesForUserId:userId connectionId:connectionId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *timelineList;
            
            if(networkCallback.success) {
                timelineList = [AFBlipVideoModelFactory listOfTimelineObjectsForData:networkCallback.responseData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(timelineList, networkCallback);
            });
        });
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create timeline
- (void)postCreateTimeline:(NSString *)userId accessToken:(NSString *)accessToken coverImageData:(NSData *)coverImageData description:(NSString *)description connectionId:(NSString *)connectionId  success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postCreateTimeline:userId accessToken:accessToken coverImageData:coverImageData description:description connectionId:connectionId success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch favourite videos
- (void)favouriteVideosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipVideoList)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource fetchFavouriteVideosAtPageIndex:pageIndex userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AFBlipVideoTimelineModel *timelineModel;
            
            if(networkCallback.success) {
                timelineModel = [AFBlipVideoModelFactory videoPlaylistModelForData:networkCallback.responseData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(timelineModel, networkCallback);
            });
        });
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Set favourite video
- (void)setFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(long)date timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postSetFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoId favouritedDate:date timelineId:timelineId success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Remove favourite video
- (void)removeFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postRemoveFavouriteVideoWithUserId:userId accessToken:accessToken videoId:videoId success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Set flagged video
- (void)setFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postSetFlaggedVideoWithUserId:userId accessToken:accessToken videoId:videoId videoPath:videoPath timelineId:timelineId success:^(AFBlipBaseNetworkModel *networkCallback) {

        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Remove flagged video
- (void)removeFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postRemoveFlaggedVideoWithUserId:userId accessToken:accessToken videoId:videoId videoPath:videoPath success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Delete video
- (void)removeVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource postDeleteVideoWithUserId:userId accessToken:accessToken videoId:videoId videoPath:videoPath success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Video by Id
- (void)fetchVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipVideoById)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipVideoModelDatasource *dataSource = [[AFBlipVideoModelDatasource alloc] init];
    [dataSource fetchVideoWithUserId:userId accessToken:accessToken videoId:videoId success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AFBlipVideoModel *videoModel;
            
            if(networkCallback.success) {
                videoModel = [AFBlipVideoModelFactory videoModelForData:networkCallback.responseData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(videoModel, networkCallback);
            });
        });
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - List of timeline models for data 
+ (NSArray *)listOfTimelineObjectsForData:(NSDictionary *)data {
    
    NSArray *timelineDataArray         = data[@"timelines"];
    if(!timelineDataArray || ![timelineDataArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *timelineModelArray = [[NSMutableArray alloc] initWithCapacity:timelineDataArray.count];
    
    for(id timelineDataObject in timelineDataArray) {
        
        AFBlipVideoTimelineModel *timelineModel = [AFBlipVideoModelFactory videoPlaylistModelForData:timelineDataObject];
        [timelineModelArray addObject:timelineModel];
    }
    
    return timelineModelArray;
}

#pragma mark - Timeline model
+ (AFBlipVideoTimelineModel *)videoPlaylistModelForData:(NSDictionary *)data {
    
    AFBlipVideoTimelineModel *model   = [[AFBlipVideoTimelineModel alloc] init];
    model.type                        = AFBlipVideoTimelineModelType_None;
    
    //Keys
    static dispatch_once_t onceToken;
    static NSString *keyVideos;
    static NSString *keyVideoCount;
    static NSString *keyTotalPages;
    static NSString *keyTimelineId;
    static NSString *keyCoverImage;
    static NSString *keyTitle;
    static NSString *keyDescription;
    static NSString *keyDate;
    
    dispatch_once(&onceToken, ^{
        keyVideos       = @"videos";
        keyVideoCount   = @"video_count";
        keyTotalPages   = @"total_pages";
        keyTimelineId   = @"timeline_id";
        keyCoverImage   = @"friend_image";
        keyTitle        = @"title";
        keyDescription  = @"description";
        keyDate         = @"date";
    });
    
    //Video array
    NSArray *videoDataArray           = data[keyVideos];
    NSMutableArray *videoArray        = [[NSMutableArray alloc] initWithCapacity:videoDataArray.count];

    for(id videoDataObject in videoDataArray) {

        AFBlipVideoModel *videoModel  = [AFBlipVideoModelFactory videoModelForData:videoDataObject];
        [videoArray addObject:videoModel];
    }

    [model setValue:videoArray forKey:keyVideos];

    //Totla video count
    NSNumber *numberOfVideos          = data[keyVideoCount];
    if(numberOfVideos) {
        model.totalNumberOfVideos     = [numberOfVideos unsignedIntegerValue];
    }
    //Total page count
    NSNumber *numberOfPages           = data[keyTotalPages];
    if(numberOfPages) {
        model.totalNumberOfPages      = [numberOfPages unsignedIntegerValue];
    }

    //Timeline Id
    id timelineIds                    = data[keyTimelineId];
    if(timelineIds) {
        if([timelineIds isKindOfClass:[NSArray class]]) {
            model.timelineIds         = timelineIds;
        } else if([timelineIds isKindOfClass:[NSString class]]) {
            model.timelineIds         = @[timelineIds];
        }
    }

    //Cover image
    model.timelineFriendImageURLString = data[keyCoverImage];

    //Title
    model.timelineTitle               = data[keyTitle];

    //Description
    model.timelineDescription         = data[keyDescription];
    
    return model;
}

#pragma mark - Video model
+ (AFBlipVideoModel *)videoModelForData:(NSDictionary *)data {
    
    AFBlipVideoModel *model = [[AFBlipVideoModel alloc] init];
    
    //Keys
    static dispatch_once_t onceToken;
    static NSString *keyDate;
    static NSString *keyThumbnailPath;
    static NSString *keyThumbnailPathString;
    static NSString *keyVideoId;
    static NSString *keyVideoIdString;
    static NSString *keyVideoPath;
    static NSString *keyVideoURLString;
    static NSString *keyTimelineId;
    static NSString *keyTimelineIdString;
    static NSString *keyUser;
    static NSString *keyUserName;
    static NSString *keyUserThumbnail;
    static NSString *keyUserThumbnailString;
    static NSString *keyDescription;
    static NSString *keyVideoDescription;
    static NSString *keyFavourited;
    static NSString *keyFlagged;
    
    dispatch_once(&onceToken, ^{
        keyDate                = @"date";
        keyThumbnailPath       = @"thumbnail_path";
        keyThumbnailPathString = @"thumbnailURLString";
        keyVideoId             = @"video_id";
        keyVideoIdString       = @"videoId";
        keyVideoPath           = @"video_path";
        keyVideoURLString      = @"videoURL";
        keyTimelineId          = @"timeline_id";
        keyTimelineIdString    = @"timelineId";
        keyUser                = @"user";
        keyUserName            = @"userName";
        keyUserThumbnail       = @"user_thumbnail";
        keyUserThumbnailString = @"userThumbnailURLString";
        keyDescription         = @"description";
        keyVideoDescription    = @"videoDescription";
        keyFavourited          = @"favourited";
        keyFlagged             = @"flagged";
    });
    
    //User info
    
    model.date = [data[keyDate] longValue];
    [model setValue:data[keyThumbnailPath] forKey:keyThumbnailPathString];
    [model setValue:data[keyVideoId] forKey:keyVideoIdString];
    [model setValue:data[keyVideoPath] forKey:keyVideoURLString];
    [model setValue:data[keyTimelineId] forKey:keyTimelineIdString];
    [model setValue:data[keyUser] forKey:keyUserName];
    [model setValue:data[keyUserThumbnail] forKeyPath:keyUserThumbnailString];
    [model setValue:data[keyDescription] forKey:keyVideoDescription];
    [model setValue:data[keyFavourited] forKey:keyFavourited];
    [model setValue:data[keyFlagged] forKey:keyFlagged];
    
    return model;
}

#pragma mark - Timeline list
+ (NSArray *)timelineListForData:(NSDictionary *)data {
    
    NSArray *timelineList = data[@"timelines"];
    
    return timelineList;
}

@end
