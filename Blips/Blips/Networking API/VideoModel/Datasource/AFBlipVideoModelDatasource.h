//
//  AFBlipVideoModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipBaseNetworkDatasource.h"

@interface AFBlipVideoModelDatasource : AFBlipBaseNetworkDatasource

#pragma mark - Video creation
- (void)postCreateVideoModelWithUserId:(NSString *)userId timelineId:(NSString *)timelineId videoContent:(NSData *)videoContent date:(long)date accessToken:(NSString *)accessToken videoThumbnail:(NSData *)videoThumbnail videoDescription:(NSString *)description success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Videos at page index
- (void)fetchVideosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken timelineIds:(NSArray *)timelineIds singleUserConnectionOnly:(BOOL)singleUserConnectionOnly success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Create timeline
- (void)postCreateTimeline:(NSString *)userId accessToken:(NSString *)accessToken coverImageData:(NSData *)coverImageData description:(NSString *)description connectionId:(NSString *)connectionId  success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Timeline fetch
- (void)fetchAllTimelinesForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Timeline by connection id fetch
- (void)fetchAllTimelinesForUserId:(NSString *)userId connectionId:(NSString *)connectionId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Fetch favourite videos
- (void)fetchFavouriteVideosAtPageIndex:(NSUInteger)pageIndex userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Set favourite video
- (void)postSetFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(long)date timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Remove favourite video
- (void)postRemoveFavouriteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Set flagged video
- (void)postSetFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath timelineId:(NSString *)timelineId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Remove flagged video
- (void)postRemoveFlaggedVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Delete video
- (void)postDeleteVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId videoPath:(NSString *)videoPath success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

#pragma mark - Video by id
- (void)fetchVideoWithUserId:(NSString *)userId accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end