//
//  AFBlipStoreKitManager.h
//  Blips
//
//  Created by Andrew Apperley on 2014-09-23.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AFBlipStoreKitManagerTransactionCompleteBlock)(BOOL success);

@interface AFBlipStoreKitManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, copy)AFBlipStoreKitManagerTransactionCompleteBlock listnerBlock;

@end