//
//  AFBlipVideoModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipDateFormatter.h"
#import "AFBlipVideoModelDatasource.h"
#import "AFBlipAWSS3AbstractFactory.h"

NSString *kAFBlipVideoModelParameterKeyUserId                 = @"user_id";
NSString *kAFBlipVideoModelParameterKeyAcessToken             = @"access_token";

//Video creation
NSString *kAFBlipVideoModelsParameterKeySecondUser            = @"user2";

//Videos at page index
NSString *kAFBlipVideoModelsEndpointURL                       = @"/video/getVideos/";
NSString *kAFBlipVideoModelsParameterKeyTimelineIds           = @"timeline_ids";
NSString *kAFBlipVideoModelsParameterKeyPage                  = @"page";
NSString *kAFBlipVideoModelsParameterKeyType                  = @"type";

//Timeline
NSString *kAFBlipCreateTimelineEndpointURL                    = @"/video/timeline/";
NSString *kAFBlipTimelineEndpointURL                          = @"/video/getTimelines/";
NSString *kAFBlipTimelineByConnectionEndpointURL              = @"/video/timelines/";
NSString *kAFBlipTimelineModelParameterKeyDescription         = @"description";
NSString *kAFBlipTimelineModelParameterKeyConnectionId        = @"connection_id";
NSString *kAFBlipTimelineModelParameterKeyCoverImage          = @"cover_image";

//Video creation
NSString *kAFBlipVideoCreationModelEndpointURL                = @"/video/";
NSString *kAFBlipVideoCreationModelParameterKeyRelationshipId = @"timeline_id";
NSString *kAFBlipVideoCreationModelParameterKeyVideoContent   = @"video_content";
NSString *kAFBlipVideoCreationModelParameterKeyDate           = @"date";
NSString *kAFBlipVideoCreationModelParameterKeyThumbnail      = @"video_thumbnail";
NSString *kAFBlipVideoCreationModelParameterKeyDescription    = @"description";

//Favourites
NSString *kAFBlipFavouriteVideoModelGetEndpointURL            = @"/video/favourites/";
NSString *kAFBlipFavouriteVideoModelSetEndpointURL            = @"/video/setfavourite/";
NSString *kAFBlipFavouriteVideoModelRemoveEndpointURL         = @"/video/unsetfavourite/";
NSString *kAFBlipFavouriteVideoModelVideoId                   = @"video_id";
NSString *kAFBlipFavouriteVideoModelFavouriteDate             = @"fav_date";
NSString *kAFBlipFavouriteVideoModelFavouriteTimelineId       = @"timeline_id";

//Flags
NSString *kAFBlipFlaggedVideoModelEndpointURL                 = @"/video/flagged/";
NSString *kAFBlipFlaggedVideoModelParameterKeyFlagged         = @"flagged";
NSString *kAFBlipFlaggedVideoModelParameterKeyVideoPath       = @"video_path";

//Delete video
NSString *kAFBlipDeleteVideoModelEndpointURL                  = @"/video/delete/";

//Video by Id
NSString *kAFBlipFavouriteVideoModelByIdEndpointURL           = @"/video/video_by_id";

@interface AFBlipVideoModelDatasource () {
    
    NSURLSessionDataTask *_currentTimelineFetchDataTask;
}

@end

@implementation AFBlipVideoModelDatasource

#pragma mark - Video creation
- (void)postCreateVideoModelWithUserId:(NSString *)userId timelineId:(NSString *)timelineId videoContent:(NSData *)videoContent date:(long)date accessToken:(NSString *)accessToken videoThumbnail:(NSData *)videoThumbnail videoDescription:(NSString *)description success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    [_currentTimelineFetchDataTask cancel];
    
    NSDictionary *parameters = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoCreationModelParameterKeyRelationshipId : timelineId,
                                 kAFBlipVideoCreationModelParameterKeyDate : @(date),
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipVideoCreationModelParameterKeyDescription : description,
                                 kAFBlipVideoCreationModelParameterKeyVideoContent : [videoContent base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],
                                 kAFBlipVideoCreationModelParameterKeyThumbnail : [videoThumbnail  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    
    _currentTimelineFetchDataTask = [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipVideoCreationModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        if (networkCallback.success) {
            success(networkCallback);
        } else {
            failure(nil);
        }
        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Videos at page index
- (void)fetchVideosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken timelineIds:(NSArray *)timelineIds singleUserConnectionOnly:(BOOL)singleUserConnectionOnly success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {

    [_currentTimelineFetchDataTask cancel];
    
    if (!timelineIds || [timelineIds isEqual:[NSNull null]]) {
        return;
    }

    NSString *timelineType          = singleUserConnectionOnly ? @"timelineType" : @"summaryType";
    NSString *timelineArrayAsString = [timelineIds componentsJoinedByString:@","];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipVideoModelsParameterKeyType : timelineType,
                                 kAFBlipVideoModelsParameterKeyPage : [NSString stringWithFormat:@"%lu", (unsigned long)pageIndex]}];
    if(timelineArrayAsString) {
        [parameters setObject:timelineArrayAsString forKey:kAFBlipVideoModelsParameterKeyTimelineIds];
    }
    
    _currentTimelineFetchDataTask = [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipVideoModelsEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
    
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create timeline
- (void)postCreateTimeline:(NSString *)userId accessToken:(NSString *)accessToken coverImageData:(NSData *)coverImageData description:(NSString *)description connectionId:(NSString *)connectionId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    [_currentTimelineFetchDataTask cancel];

    NSDictionary *parameters = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipTimelineModelParameterKeyDescription : description,
                                 kAFBlipTimelineModelParameterKeyConnectionId : connectionId};

    _currentTimelineFetchDataTask = [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipCreateTimelineEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        if (networkCallback.success) {

            AFBlipAWSS3AbstractFactory *imageFactory = [AFBlipAWSS3AbstractFactory sharedAWS3Factory];
            [imageFactory setObjectWithData:coverImageData forKey:networkCallback.responseData[@"Timeline"][@"coverImage"] completion:^{
                success(networkCallback);
            } failure:^(NSError *error) {
                success(networkCallback);
            }];
        } else {
            failure(nil);
        }        
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Timeline fetch
- (void)fetchAllTimelinesForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    [_currentTimelineFetchDataTask cancel];

    NSDictionary *parameters = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken};
    _currentTimelineFetchDataTask = [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipTimelineEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
    
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Timeline by connection id fetch
- (void)fetchAllTimelinesForUserId:(NSString *)userId connectionId:(NSString *)connectionId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    [_currentTimelineFetchDataTask cancel];

    NSDictionary *parameters = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipTimelineModelParameterKeyConnectionId : connectionId};
    _currentTimelineFetchDataTask = [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipTimelineByConnectionEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch favourite videos
- (void)fetchFavouriteVideosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    [_currentTimelineFetchDataTask cancel];

    NSDictionary *parameters = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipVideoModelsParameterKeyPage : [NSString stringWithFormat:@"%lu", (unsigned long)pageIndex]};
    
    _currentTimelineFetchDataTask = [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipFavouriteVideoModelGetEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Set favourite video
- (void)postSetFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(long)date timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters        = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipFavouriteVideoModelVideoId : videoId,
                                 kAFBlipFavouriteVideoModelFavouriteDate : @(date),
                                 kAFBlipFavouriteVideoModelFavouriteTimelineId: timelineId};

    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipFavouriteVideoModelSetEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Remove favourite video
- (void)postRemoveFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters   = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                 kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                 kAFBlipFavouriteVideoModelVideoId : videoId};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipFavouriteVideoModelRemoveEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Set flagged video
- (void)postSetFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    if(!videoPath) {
        return;
    }
    
    videoPath = [self trimVideoPathToFolder:videoPath];
    
    NSDictionary *parameters   = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                   kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                   kAFBlipFavouriteVideoModelVideoId : videoId,
                                   kAFBlipFlaggedVideoModelParameterKeyVideoPath: videoPath,
                                   kAFBlipFlaggedVideoModelParameterKeyFlagged: @(YES)};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipFlaggedVideoModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Remove flagged video
- (void)postRemoveFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    if(!videoPath) {
        return;
    }
    
    videoPath = [self trimVideoPathToFolder:videoPath];
    
    NSDictionary *parameters   = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                   kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                   kAFBlipFavouriteVideoModelVideoId : videoId,
                                   kAFBlipFlaggedVideoModelParameterKeyVideoPath: videoPath,
                                   kAFBlipFlaggedVideoModelParameterKeyFlagged: @(NO)};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipFlaggedVideoModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Delete video
- (void)postDeleteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    if(!videoPath) {
        return;
    }
    
    videoPath = [self trimVideoPathToFolder:videoPath];
    
    NSDictionary *parameters   = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                   kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                   kAFBlipFavouriteVideoModelVideoId : videoId,
                                   kAFBlipFlaggedVideoModelParameterKeyVideoPath: videoPath};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipDeleteVideoModelEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

- (NSString *)trimVideoPathToFolder:(NSString *)videoPath {
    
    //Trim string from 'user_content/videos/528d209f14277a3c6971c4f56f23bb02a3128609114a9723ed8c21e6e300b56a/3/1414117122/9cdb854d0e82eed5f40d8951f9c1e7297b0ba3f422150a8576840b1f8ea690f6.m4v' to 'user_content/videos/528d209f14277a3c6971c4f56f23bb02a3128609114a9723ed8c21e6e300b56a/3/1414117122/'
    NSUInteger videoPathLastSlashIndex = [videoPath rangeOfString:@"/" options:NSBackwardsSearch].location;
    if(videoPathLastSlashIndex != NSNotFound) {
        videoPath = [videoPath substringToIndex:videoPathLastSlashIndex + 1];
    }
    
    return videoPath;
}

#pragma mark - Video by id
- (void)fetchVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *parameters   = @{kAFBlipVideoModelParameterKeyUserId : userId,
                                   kAFBlipVideoModelParameterKeyAcessToken : accessToken,
                                   kAFBlipFavouriteVideoModelVideoId : videoId};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipFavouriteVideoModelByIdEndpointURL parameters:parameters success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

- (void)dealloc {
    _currentTimelineFetchDataTask = nil;
}

@end