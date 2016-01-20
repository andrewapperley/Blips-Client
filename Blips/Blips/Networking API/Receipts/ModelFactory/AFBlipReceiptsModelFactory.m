//
//  AFBlipReceiptsModelFactory.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-23.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipReceiptsModelFactory.h"
#import "AFBlipReceiptsDatasource.h"

@implementation AFBlipReceiptsModelFactory

- (void)submitReceiptForTransactionWithReceiptData:(NSData *)receiptData receiptDate:(NSInteger)receiptDate receiptProductID:(NSString *)receiptProductID userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    if (!receiptData || !receiptDate || !receiptProductID || !userId || !accessToken) {
        if (failure) {
            failure(nil);
            return;
        }
    }
    
    AFBlipReceiptsDatasource *datasource = [[AFBlipReceiptsDatasource alloc] init];
    [datasource submitReceiptForTransactionWithReceiptData:receiptData receiptDate:receiptDate receiptProductID:receiptProductID userId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        [self receiveReceiptsForUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
            if (success) {
                success(networkCallback);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)receiveReceiptsForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure {
    
    AFBlipReceiptsDatasource *datasource = [[AFBlipReceiptsDatasource alloc] init];
    [datasource receiveReceiptsForUserId:userId accessToken:accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        if (networkCallback.success) {
            if ([networkCallback.responseData[@"receipts"] count] > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:networkCallback.responseData[@"receipts"] forKey:@"blipsUserReceipts"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        success(networkCallback);
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end