//
//  AFBlipReceiptsDatasource.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-23.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipReceiptsDatasource.h"

NSString *kAFBlipReceiptsDatasource_SubmitEndpointURL              = @"/receipts/";
NSString *kAFBlipReceiptsDatasource_RetrieveEndpointURL            = @"/receipts/retrieve";
NSString *kAFBlipReceiptsDatasource_ParameterKeyAccessToken        = @"access_token";
NSString *kAFBlipReceiptsDatasource_ParameterKeyUserID             = @"user_id";
NSString *kAFBlipReceiptsDatasource_ParameterData                  = @"receiptData";
NSString *kAFBlipReceiptsDatasource_ParameterProduct               = @"receiptProductID";
NSString *kAFBlipReceiptsDatasource_ParameterDate                  = @"receiptDate";

@implementation AFBlipReceiptsDatasource

- (void)submitReceiptForTransactionWithReceiptData:(NSData *)receiptData receiptDate:(NSInteger)receiptDate receiptProductID:(NSString *)receiptProductID userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *params = @{kAFBlipReceiptsDatasource_ParameterData: [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn],
                             kAFBlipReceiptsDatasource_ParameterKeyUserID: userId,
                             kAFBlipReceiptsDatasource_ParameterKeyAccessToken: accessToken,
                             kAFBlipReceiptsDatasource_ParameterProduct: receiptProductID,
                             kAFBlipReceiptsDatasource_ParameterDate: @(receiptDate)};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_POST endpointURLString:kAFBlipReceiptsDatasource_SubmitEndpointURL parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)receiveReceiptsForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    NSDictionary *params = @{kAFBlipReceiptsDatasource_ParameterKeyUserID: userId,
                             kAFBlipReceiptsDatasource_ParameterKeyAccessToken: accessToken};
    
    [self makeURLRequestWithType:kAFBlipNetworkCallType_GET endpointURLString:kAFBlipReceiptsDatasource_RetrieveEndpointURL parameters:params success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (success) {
            success(networkCallback);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end