//
//  AFBlipVideoViewControllerMediatorStatics.m
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import "AFBlipVideoViewControllerMediatorStatics.h"
#import "AFPlatformUtility.h"

AFBlipVideoViewControllerMediatorMovementDirection movementDirectionFromState(AFBlipVideoViewControllerMediatorState fromState, AFBlipVideoViewControllerMediatorState toState) {
    
    if(fromState == AFBlipVideoViewControllerMediatorState_None) {
        return AFBlipVideoViewControllerMediatorMovementDirection_RightToCenter;
    }
    
    AFBlipVideoViewControllerMediatorMovementDirection direction = AFBlipVideoViewControllerMediatorMovementDirection_RightToCenter;
    
    
    //Left to center movement
    //Filter -> Capture
    if((fromState == AFBlipVideoViewControllerMediatorState_Filter && toState == AFBlipVideoViewControllerMediatorState_Capture) ||
       //Share -> Filter
       (fromState == AFBlipVideoViewControllerMediatorState_Share && toState == AFBlipVideoViewControllerMediatorState_Filter)) {
        
        direction = AFBlipVideoViewControllerMediatorMovementDirection_LeftToCenter;
    }
    
    return direction;
}

CGSize defaultVideoPlayerSize() {
    
    return CGSizeMake(300.0f, 300.0f);
}

NSArray* const defaultVideoQualityBlacklist() {
    return @[@"iPhone3,1", @"iPhone3,3", @"iPhone4,1", @"iPod5,1", @"iPad2,1", @"iPad2,2", @"iPad2,3", @"iPad2,4", @"iPad2,5", @"iPad2,6", @"iPad2,7", @"iPad3,1", @"iPad3,2", @"iPad3,3"];
}

AFBlipVideoCaptureQuality defaultVideoQuality() {
    return AFBlipVideoCapturePreset_640x480;//([AFPlatformUtility isSupported:defaultVideoQualityBlacklist()]) ? AFBlipVideoCapturePreset_High : AFBlipVideoCapturePreset_Medium ;
    
}