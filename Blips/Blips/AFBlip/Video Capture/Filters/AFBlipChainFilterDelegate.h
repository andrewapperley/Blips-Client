//
//  AFBlipChainFilterDelegate.h
//  Blips
//
//  Created by Andrew Apperley on 2014-08-26.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

@class GPUImageMovie;

@protocol AFBlipChainFilterDelegate <NSObject>

@required
- (NSArray *)chainFilters;
- (void)cleanupFilter;
@end