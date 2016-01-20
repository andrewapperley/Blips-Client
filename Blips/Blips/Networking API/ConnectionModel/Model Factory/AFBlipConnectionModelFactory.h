//
//  AFBlipConnectionModelFactory.h
//  Blips
//
//  Created by Andrew Apperley on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseNetworkModel.h"
#import "AFBlipBaseNetworkStatics.h"
#import "AFBlipUserModel.h"
#import "AFBlipConnectionModel.h"

typedef void(^AFBlipConnectionCreationSuccess)(AFBlipBaseNetworkModel* networkCallback);
typedef void(^AFBlipConnectionStatusChange)(AFBlipBaseNetworkModel* networkCallback);
typedef void(^AFBlipConnectionSuccess)(AFBlipBaseNetworkModel* networkCallback, AFBlipConnectionModel *connectionModel);
typedef void(^AFBlipConnectionListSuccess)(AFBlipBaseNetworkModel* networkCallback, NSArray* connections, NSArray *pendingRequests);

@interface AFBlipConnectionModelFactory : NSObject

- (void)createConnectionWithUserID:(NSString *)userID otherUser:(NSString *)otherUser accessToken:(NSString *)accessToken success:(AFBlipConnectionCreationSuccess)success failure:(AFBlipBaseNetworkFailure)failure;
- (void)changeConnectionStatusWithUserID:(NSString *)username connectionID:(NSString *)connectionID status:(BOOL)status accessToken:(NSString *)accessToken success:(AFBlipConnectionStatusChange)success failure:(AFBlipBaseNetworkFailure)failure;
- (void)connectionListWithUserID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipConnectionListSuccess)success failure:(AFBlipBaseNetworkFailure)failure;
- (void)connectionWithTimelineID:(NSString *)timelineID success:(AFBlipConnectionSuccess)success failure:(AFBlipBaseNetworkFailure)failure;
@end