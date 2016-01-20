//
//  AFBlipVideoViewControllerMediatorStatics.h
//  Blips
//
//  Created by Jeremy Fuellert on 2014-07-03.
//  Copyright (c) 2014 AF-Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AFBlipVideoViewControllerMediatorState) {
    AFBlipVideoViewControllerMediatorState_None,
    AFBlipVideoViewControllerMediatorState_ViewVideo,
    AFBlipVideoViewControllerMediatorState_Capture,
    AFBlipVideoViewControllerMediatorState_Filter,
    AFBlipVideoViewControllerMediatorState_Share
};

typedef NS_ENUM(NSUInteger, AFBlipVideoViewControllerMediatorMovementDirection) {
    AFBlipVideoViewControllerMediatorMovementDirection_LeftToCenter,
    AFBlipVideoViewControllerMediatorMovementDirection_RightToCenter
};

typedef NS_ENUM(NSInteger, AFBlipVideoCaptureQuality) {
    AFBlipVideoCapturePreset_Low,
    AFBlipVideoCapturePreset_Medium,
    AFBlipVideoCapturePreset_High,
    AFBlipVideoCapturePreset_640x480,
    AFBlipVideoCapturePreset_960x540,
    AFBlipVideoCapturePreset_InputPriority
};

typedef NS_ENUM(NSInteger, AFBlipVideoPlayerState) {
    AFBlipVideoPlayerState_None = -1,
    AFBlipVideoPlayerState_Record,
    AFBlipVideoPlayerState_Play,
    AFBlipVideoPlayerState_Idle
};

AFBlipVideoViewControllerMediatorMovementDirection movementDirectionFromState(AFBlipVideoViewControllerMediatorState fromState, AFBlipVideoViewControllerMediatorState toState);

CGSize defaultVideoPlayerSize();
AFBlipVideoCaptureQuality defaultVideoQuality();
