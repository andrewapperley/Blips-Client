//
//  AFBlipAWS_S3Handler.m
//  Blips
//
//  Created by Andrew Apperley on 2014-05-18.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipAWSS3AbstractFactory.h"
#import "AFBlipAmazonS3Statics.h"
#import "AFHash.h"
#import <AFAmazonS3Manager.h>
#import "S3.h"

/** NSError Constants */
NSString* const kAFBlipAWSErrorDomain               = @"s3/ca.blips.api";
const NSInteger kAFBlipAWSErrorCode                 = 1;
NSString* const kAFBlipAWSErrorObjectKey            = @"object";
NSString* const kAFBlipAWSErrorReasonKey            = @"reason";
NSString* const kAFBlipAWSErrorNoObjectKey          = @"NoSuchKey";

static BOOL _doesNotUseAmazon            = YES;

@interface AFBlipAWSS3AbstractFactory() {
    
    AFAmazonS3Manager *_amazonS3Manager;
}

@end

@implementation AFBlipAWSS3AbstractFactory

#pragma mark - Init
+ (AFBlipAWSS3AbstractFactory *)sharedAWS3Factory {

    static dispatch_once_t pred;
    static AFBlipAWSS3AbstractFactory *factory;
    
    dispatch_once(&pred, ^{
        _doesNotUseAmazon = [[NSProcessInfo processInfo].environment[@"NON_AMAZON"] boolValue];
        factory = [[[self class] alloc] init];
    });
    
    return factory;
}

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if(self) {
        [self createAmazonManager];
    }
    return self;
}

- (void)createAmazonManager {
    
    _amazonS3Manager        = [[AFAmazonS3Manager alloc] initWithAccessKeyID:kAFBlipAWSAccessKey secret:kAFBlipAWSSecretKey];
    _amazonS3Manager.responseSerializer.acceptableContentTypes = [_amazonS3Manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"application/octet-stream", @"image/jpeg"]];
    _amazonS3Manager.requestSerializer.bucket = kAFBlipAWSS3Bucket;
    _amazonS3Manager.requestSerializer.region = AFAmazonS3USStandardRegion;
}

- (void)setObjectWithData:(NSData *)object forKey:(NSString *)key completion:(AFBlipAWSPutObjectBlock)completion failure:(AFBlipAWSPutObjectFailureBlock)failure {
    
    NSString *hashedKey = MD5(key);
    NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), hashedKey];
    [[NSFileManager defaultManager] createFileAtPath:path contents:object attributes:nil];
    [self setObjectWithURL:[NSURL fileURLWithPath:path] forKey:key length:@(object.length) completion:^{
        if (completion) {
            completion();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)setObjectWithURL:(NSURL *)objectPath forKey:(NSString *)key length:(NSNumber *)length completion:(AFBlipAWSPutObjectBlock)completion failure:(AFBlipAWSPutObjectFailureBlock)failure {

    if (!_doesNotUseAmazon && key) {
        AWSS3TransferManagerUploadRequest *uploadRequest = [[AWSS3TransferManagerUploadRequest alloc] init];
        uploadRequest.bucket = kAFBlipAWSS3Bucket;
        uploadRequest.key = key;
        uploadRequest.body = objectPath;
        uploadRequest.contentLength = length;
        
        [[[AWSS3TransferManager defaultS3TransferManager] upload:uploadRequest] continueWithBlock:^id(BFTask *task) {
            if (task.completed && task.result) {
                if (completion) {
                    completion();
                }
            } else {
                if (failure) {
                    failure(task.error);
                }
            }
            return nil; // Why would you need to return anything here?
        }];

    } else {
        completion();
    }
}


- (AFHTTPRequestOperation *)objectForKey:(NSString *)key completion:(AFBlipAWSGetObjectBlock)completion failure:(AFBlipAWSGetObjectFailureBlock)failure {

    if (!_doesNotUseAmazon && key) {

        return [_amazonS3Manager getObjectWithPath:key progress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
        } success:^(id responseObject, NSData *responseData) {
            if(completion) {
                completion(responseData);
            }
            
        } failure:^(NSError *error) {
            if(failure) {
                error = [NSError errorWithDomain:kAFBlipAWSErrorDomain code:kAFBlipAWSErrorCode userInfo:@{kAFBlipAWSErrorObjectKey: key, kAFBlipAWSErrorReasonKey: (!error.localizedFailureReason) ? @"Unknown Error" : error.localizedFailureReason, kAFBlipAWSErrorNoObjectTitleKey: kAFBlipAWSErrorNoObjectTitle, kAFBlipAWSErrorNoObjectMessageKey: kAFBlipAWSErrorNoObjectMessage}];
                
                failure(error);
            }
        }];
    }
    return nil;
}

- (void)cancelAllOperations {
    
    [_amazonS3Manager.operationQueue cancelAllOperations];
}

- (void)dealloc {
    [self cancelAllOperations];
}

@end