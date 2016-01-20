//
//  AFBlipTimelineCanvasLayout.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFBlipTimelineCanvasLayout.h"

@implementation AFBlipTimelineCanvasLayout

#pragma mark - Init
- (instancetype)init {
    
    self = [super init];
    if(self) {
        
        self.minimumLineSpacing         = 0;
        self.minimumInteritemSpacing    = 0;
    }
    return self;
}

@end
