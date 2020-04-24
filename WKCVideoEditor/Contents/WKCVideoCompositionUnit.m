//
//  WKCCompositionUnit.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoCompositionUnit.h"

@interface WKCVideoCompositionUnit()

@property (nonatomic, strong) AVMutableComposition * composition;


@end

@implementation WKCVideoCompositionUnit

- (instancetype)init
{
    if (self = [super init]) {
        _composition = [AVMutableComposition composition];
    }
    
    return self;
}

- (AVMutableCompositionTrack *)createAVideoCompostionTrack
{
    return [_composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
}

- (AVMutableCompositionTrack *)createAAudioCompostionTrack
{
    return [_composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
}

@end
