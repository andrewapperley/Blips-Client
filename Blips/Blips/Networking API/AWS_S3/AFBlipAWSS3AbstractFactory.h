//
//  AFBlipAWS_S3Handler.h
//  Blips
//
//  Created by Andrew Apperley on 2014-05-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@class S3PutObjectResponse;

typedef void(^AFBlipAWSGetObjectBlock)(NSData* data);
typedef void(^AFBlipAWSGetObjectFailureBlock)(NSError *error);
typedef void(^AFBlipAWSPutObjectBlock)(void);
typedef void(^AFBlipAWSPutObjectFailureBlock)(NSError *error);

@interface AFBlipAWSS3AbstractFactory : NSObject

/** Sets an object into AWS S3 by key. */
- (void)setObjectWithURL:(NSURL *)objectPath forKey:(NSString *)key length:(NSNumber *)length completion:(AFBlipAWSPutObjectBlock)completion failure:(AFBlipAWSPutObjectFailureBlock)failure;

/** Sets an object into AWS S3 by key but onto the filesystem first */
- (void)setObjectWithData:(NSData *)object forKey:(NSString *)key completion:(AFBlipAWSPutObjectBlock)completion failure:(AFBlipAWSPutObjectFailureBlock)failure;

/** Gets object from AWS S3 from a key. */
- (AFHTTPRequestOperation *)objectForKey:(NSString *)key completion:(AFBlipAWSGetObjectBlock)completion failure:(AFBlipAWSGetObjectFailureBlock)failure;

+ (AFBlipAWSS3AbstractFactory *)sharedAWS3Factory;

@end