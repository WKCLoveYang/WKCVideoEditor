//
//  WKCAssetUnit.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WKCVideoAssetUnit : NSObject

/// current asset
@property (nonatomic, strong, readonly) AVAsset * asset;
/// asset's video track
@property (nonatomic, strong, readonly) AVAssetTrack * videoTrack;
/// asset's audio track
@property (nonatomic, strong, readonly) AVAssetTrack * audioTrack;
/// asset's startTime
@property (nonatomic, assign, readonly) CMTime start;
/// asset's duration
@property (nonatomic, assign, readonly) CMTime duration;
/// asset's time range
@property (nonatomic, assign, readonly) CMTimeRange range;

/// init method
/// @param content video path or asset
- (instancetype)initWithContent:(id)content;

@end

