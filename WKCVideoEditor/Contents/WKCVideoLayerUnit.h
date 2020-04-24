//
//  WKCVideoLayerUnit.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WKCVideoLayerUnit : NSObject

@property (nonatomic, strong, readonly) AVMutableVideoComposition * videoComposition;
@property (nonatomic, strong, readonly) CALayer * parentLayer;
@property (nonatomic, strong, readonly) CALayer * videoLayer;

- (instancetype)initWithAsset:(AVAsset *)asset
                   assetTrack:(AVAssetTrack *)assetTrack
               intoVideoTrack:(AVMutableCompositionTrack *)videoTrack;

- (void)addBgLayer:(CALayer *)layer;
- (void)addLayers:(NSArray <CALayer *> *)layers;

@end

