//
//  AFBlipStoreKitManager.m
//  Blips
//
//  Created by Andrew Apperley on 2014-09-23.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipStoreKitManager.h"
#import <StoreKit/StoreKit.h>
#import "AFBlipReceiptsModelFactory.h"
#import "AFBlipKeychain.h"
#import "AFBlipUserModelSingleton.h"
#import "AFBlipUserModel.h"
#import "CargoBay.h"

@interface AFBlipStoreKitManager () <SKPaymentTransactionObserver> {
    BOOL _verifying;
}

@end

@implementation AFBlipStoreKitManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static AFBlipStoreKitManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[AFBlipStoreKitManager alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:sharedInstance];
    });
    return sharedInstance;
}

#pragma mark Storekit Delegate methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    for (SKDownload *download in downloads) {
        if (download.downloadState == SKDownloadStateFinished) {
            /*Copy download contents to documents folder*/
            
            NSError *error;
            
            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"AFBlipVideoFilterExtraList.json"];
            
            __unused BOOL inAppPurchaseContentsMove = [[NSFileManager defaultManager] copyItemAtPath:[NSString stringWithFormat:@"%@/Contents/AFBlipVideoFilterExtraList.json", download.contentURL.path] toPath:destinationPath error:&error];
            
            [[SKPaymentQueue defaultQueue] finishTransaction:download.transaction];
            if (_listnerBlock) {
                _listnerBlock(YES);
                _listnerBlock = NULL;
            }
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    if (_listnerBlock) {
        _listnerBlock(NO);
        _listnerBlock = NULL;
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self verifyReceipt:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    if (_listnerBlock) {
        _listnerBlock(NO);
        _listnerBlock = NULL;
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self verifyReceipt:transaction];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    /*Prepare Transaction Object for the server*/
    NSInteger timeStamp = (NSInteger)[transaction.transactionDate timeIntervalSince1970];
    NSString *productID = transaction.payment.productIdentifier;
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    AFBlipKeychain *keychain = [AFBlipKeychain keychain];
    AFBlipUserModelSingleton *userModel = [AFBlipUserModelSingleton sharedUserModel];
    /*Send data to the server*/
    AFBlipReceiptsModelFactory *modelFactory = [[AFBlipReceiptsModelFactory alloc] init];
    [modelFactory submitReceiptForTransactionWithReceiptData:receiptData receiptDate:timeStamp receiptProductID:productID userId:[userModel userModel].user_id accessToken:keychain.accessToken success:^(AFBlipBaseNetworkModel *networkCallback) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)verifyReceipt:(SKPaymentTransaction *)transaction {
    if (_verifying) {
        return;
    }
    CargoBay *receiptVerifier = [[CargoBay alloc] init];
    typeof(self) __weak wself = self;
    _verifying = YES;
    [receiptVerifier verifyTransaction:transaction password:nil success:^(NSDictionary *receipt) {
        [wself recordTransaction:transaction];
        [wself provideContent:transaction.downloads];
        _verifying = NO;
    } failure:^(NSError *error) {
        if (_listnerBlock) {
            _listnerBlock(NO);
            _listnerBlock = NULL;
        }
        _verifying = NO;
    }];
}

- (void)provideContent:(NSArray *)downloads {
    [[SKPaymentQueue defaultQueue] startDownloads:downloads];
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    abort();
}

@end