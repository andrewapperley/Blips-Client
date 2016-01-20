//
//  AFBlipReceiptsDatasource.h
//  Blips
//
//  Created by Andrew Apperley on 2014-09-23.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipBaseNetworkDatasource.h"

@interface AFBlipReceiptsDatasource : AFBlipBaseNetworkDatasource

- (void)submitReceiptForTransactionWithReceiptData:(NSData *)receiptData receiptDate:(NSInteger)receiptDate receiptProductID:(NSString *)receiptProductID userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)receiveReceiptsForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end