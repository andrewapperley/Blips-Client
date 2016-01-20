//
//  AFBlipConnectionModelFactory.m
//  Blips
//
//  Created by Andrew Apperley on 2014-03-16.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipConnectionModelFactory.h"
#import "AFBlipConnectionModelDatasource.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipKeychain.h"

@implementation AFBlipConnectionModelFactory

- (void)createConnectionWithUserID:(NSString *)userID otherUser:(NSString *)otherUser accessToken:(NSString *)accessToken success:(AFBlipConnectionCreationSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipConnectionModelDatasource* datasource = [[AFBlipConnectionModelDatasource alloc] init];
    [datasource createConnectionWithUserID:userID friendsUserID:otherUser accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

- (void)changeConnectionStatusWithUserID:(NSString *)userID connectionID:(NSString *)connectionID status:(BOOL)status accessToken:(NSString *)accessToken success:(AFBlipConnectionStatusChange)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipConnectionModelDatasource* datasource = [[AFBlipConnectionModelDatasource alloc] init];
    [datasource changeConnectionStatusWithUserID:userID connectionID:connectionID status:status accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

- (void)connectionListWithUserID:(NSString *)userID accessToken:(NSString *)accessToken success:(AFBlipConnectionListSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipConnectionModelDatasource* datasource = [[AFBlipConnectionModelDatasource alloc] init];
    AFBlipUserModel *userModel       = [AFBlipUserModelSingleton sharedUserModel].userModel;
    [datasource connectionListWithUserID:userModel.user_id accessToken:[AFBlipKeychain keychain].accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray* connections;
            NSArray* requests;

            if(networkCallback.success && networkCallback.responseData) {
                
                NSDictionary *responseDictionary = networkCallback.responseData;
                NSArray *connectionsArray        = responseDictionary[@"connections"];
                NSArray *requestsArray           = responseDictionary[@"requests"];

                connections                      = [AFBlipConnectionModelFactory connectionListFromData:connectionsArray];
                requests                         = [AFBlipConnectionModelFactory requestListFromData:requestsArray];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(networkCallback, connections, requests);
            });
        });
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

- (void)connectionWithTimelineID:(NSString *)timelineID success:(AFBlipConnectionSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipConnectionModelDatasource* datasource = [[AFBlipConnectionModelDatasource alloc] init];
    AFBlipUserModel *userModel       = [AFBlipUserModelSingleton sharedUserModel].userModel;
    [datasource connectionWithUserID:userModel.user_id accessToken:[AFBlipKeychain keychain].accessToken timelineID:timelineID success:^(AFBlipBaseNetworkModel *networkCallback) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            AFBlipConnectionModel *connection;
            
            if(networkCallback.success && networkCallback.responseData) {
                
                NSDictionary *responseDictionary = networkCallback.responseData;
                
                connection                      = [AFBlipConnectionModelFactory connectionModelFromData:responseDictionary[@"connection"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(networkCallback, connection);
            });
        });
        
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

+ (AFBlipConnectionModel *)connectionModelFromData:(NSDictionary *)data {
    AFBlipConnectionModel* connectionModel = [[AFBlipConnectionModel alloc] init];
    [connectionModel setValue:data[@"connection_id"] forKey:@"connectionId"];
    [connectionModel setValue:data[@"timeline_id"] forKey:@"timelineId"];
    
    AFBlipUserModel* friend = [AFBlipConnectionModelFactory connectionModelFromDictionary:data];
    [connectionModel setValue:friend forKey:@"connectionFriend"];
    return connectionModel;
}

+ (NSArray *)connectionListFromData:(NSArray *)data {
    
    NSMutableArray* connectionList = [[NSMutableArray alloc] initWithCapacity:data.count];
    
    for(NSDictionary* connection in data) {
        
        AFBlipConnectionModel* connectionModel = [[AFBlipConnectionModel alloc] init];
        [connectionModel setValue:connection[@"connection_id"] forKey:@"connectionId"];
        [connectionModel setValue:connection[@"timeline_id"] forKey:@"timelineId"];

        AFBlipUserModel* friend = [AFBlipConnectionModelFactory connectionModelFromDictionary:connection];
        [connectionModel setValue:friend forKey:@"connectionFriend"];
        [connectionList addObject:connectionModel];
    }
    
    return connectionList;
}

+ (NSArray *)requestListFromData:(NSArray *)data {

    NSMutableArray* requestList = [[NSMutableArray alloc] initWithCapacity:data.count];
    
    for(NSDictionary* connection in data) {
        
        AFBlipConnectionModel* connectionModel = [[AFBlipConnectionModel alloc] init];
        [connectionModel setValue:connection[@"connection_id"] forKey:@"connectionId"];
        
        AFBlipUserModel* friend = [self requestModelFromDictionary:connection[@"user"]];
        [connectionModel setValue:friend forKey:@"connectionFriend"];
        [requestList addObject:connectionModel];
    }
    
    return requestList;
}

+ (AFBlipUserModel *)connectionModelFromDictionary:(NSDictionary *)dictionary {
    
    AFBlipUserModel* friend = [[AFBlipUserModel alloc] init];
    [friend setValue:dictionary[@"friend"][@"profile_image"] forKey:@"userImageUrl"];
    [friend setValue:dictionary[@"friend"][@"display_name"] forKey:@"displayName"];
    [friend setValue:dictionary[@"friend"][@"user_id"] forKey:@"user_id"];
    [friend setValue:dictionary[@"friend"][@"deactivated"] forKey:@"isDeactivated"];
    [friend setValue:dictionary[@"new_connection"] forKey:@"isNewConnection"];

    NSNumber *videoCount = dictionary[@"video_count"];
    if(videoCount) {
        [friend setValue:videoCount forKey:@"videoCount"];
    }
    
    return friend;
}

+ (AFBlipUserModel *)requestModelFromDictionary:(NSDictionary *)dictionary {
    
    AFBlipUserModel* friend = [[AFBlipUserModel alloc] init];
    [friend setValue:dictionary[@"profile_image"] forKey:@"userImageUrl"];
    [friend setValue:dictionary[@"display_name"] forKey:@"displayName"];
    [friend setValue:dictionary[@"user_id"] forKey:@"user_id"];
    [friend setValue:dictionary[@"deactivated"] forKey:@"isDeactivated"];

    NSNumber *videoCount = dictionary[@"video_count"];
    if(videoCount) {
        [friend setValue:videoCount forKey:@"videoCount"];
    }
    
    return friend;
}

@end