//
//  AFBlipReceiptsModelFactory.h
//  Blips
//
//  Created by Andrew Apperley on 2014-09-23.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFBlipBaseNetworkModel.h"
#import "AFBlipBaseNetworkStatics.h"

@interface AFBlipReceiptsModelFactory : NSObject

- (void)submitReceiptForTransactionWithReceiptData:(NSData *)receiptData receiptDate:(NSInteger)receiptDate receiptProductID:(NSString *)receiptProductID userId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

- (void)receiveReceiptsForUserId:(NSString *)userId accessToken:(NSString *)accessToken success:(AFBlipBaseNetworkSuccess)success failure:(AFBlipBaseNetworkFailure)failure;

@end