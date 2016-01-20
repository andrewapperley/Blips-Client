//
//  AFBlipVideoModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipBaseNetworkModel.h"
#import "AFBlipBaseNetworkStatics.h"
#import "AFBlipVideoModel.h"
#import "AFBlipVideoTimelineModel.h"

typedef void(^AFBlipVideoCreationModelSuccess)(AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipVideoList)(AFBlipVideoTimelineModel *videoTimelineModel, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipTimelineIdList)(NSArray *timelineIdList, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipTimelineList)(NSArray *timelineObjectList, AFBlipBaseNetworkModel *networkCallback);
typedef void(^AFBlipVideoById)(AFBlipVideoModel *videoModel, AFBlipBaseNetworkModel *networkCallback);

@interface AFBlipVideoModelFactory : NSObject

#pragma mark - Post video creation
- (void)postVideoModelWithUserId:(NSString *)userId timelineId:(NSString *)timelineId videoContent:(NSData *)videoContent date:(long)date accessToken:(NSString *)accessToken videoThumbnail:(NSData *)videoThumbnail andVideoDescription:(NSString *)description success:(AFBlipVideoCreationModelSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Videos at page index
- (void)videosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken timelineIds:(NSArray *)timelineIds singleUserConnectionOnly:(BOOL)singleUserConnectionOnly success:(AFBlipVideoList)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Create timeline
- (void)postCreateTimeline:(NSString *)userId accessToken:(NSString *)accessToken coverImageData:(NSData *)coverImageData description:(NSString *)description connectionId:(NSString *)connectionId  success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Timeline list fetch by user id only
- (void)fetchAllTimelinesForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipTimelineList)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Timeline list fetch by connection id
- (void)fetchAllTimelinesWithConnectionId:(NSString *)connectionId userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipTimelineIdList)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Fetch favourite videos
- (void)favouriteVideosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipVideoList)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Set favourite video
- (void)setFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(long)date timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Remove favourite video
- (void)removeFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Set flagged video
- (void)setFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Remove flagged video
- (void)removeFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Delete video
- (void)removeVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Video by Id
- (void)fetchVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipVideoById)success failure:(AFBlipBaseNetworkFailure)failure;

@end