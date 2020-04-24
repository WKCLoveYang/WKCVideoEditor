//
//  WKCVideoLayerUnit.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoLayerUnit.h"

@interface WKCVideoLayerUnit()

@property (nonatomic, strong) AVAsset * asset;
@property (nonatomic, strong) AVAssetTrack * assetTrack;
@property (nonatomic, strong) AVMutableCompositionTrack * intoVideoTrack;

@property (nonatomic, strong) AVMutableVideoComposition * videoComposition;
@property (nonatomic, strong) CALayer * parentLayer;
@property (nonatomic, strong) CALayer * videoLayer;

@property (nonatomic, strong) CALayer * bgLayer;
@property (nonatomic, strong) NSMutableArray <CALayer *>* layersArray;

@end

@implementation WKCVideoLayerUnit

- (instancetype)initWithAsset:(AVAsset *)asset
                   assetTrack:(AVAssetTrack *)assetTrack
               intoVideoTrack:(AVMutableCompositionTrack *)videoTrack
{
    if (self = [super init]) {
        _asset = asset;
        _assetTrack = assetTrack;
        _intoVideoTrack = videoTrack;
        _layersArray = [NSMutableArray array];
    }
    
    return self;
}

- (AVMutableVideoComposition *)videoComposition
{
    if (!_videoComposition) {
            
        AVMutableVideoCompositionLayerInstruction * videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:_intoVideoTrack];
        [videoLayerInstruction setTransform:_intoVideoTrack.preferredTransform atTime:kCMTimeZero];
        
        AVMutableVideoCompositionInstruction * videoInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        [videoInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, _asset.duration)];
        videoInstruction.layerInstructions = @[videoLayerInstruction];
        
        _videoComposition = [AVMutableVideoComposition videoComposition];
        _videoComposition.renderSize = _assetTrack.naturalSize;
        _videoComposition.renderScale = 1.0;
        _videoComposition.frameDuration = CMTimeMake(1, 30);
        _videoComposition.instructions = @[videoInstruction];
        
        _parentLayer = [CAShapeLayer layer];
        _videoLayer = [CAShapeLayer layer];
        _parentLayer.frame = CGRectMake(0, 0, _assetTrack.naturalSize.width, _assetTrack.naturalSize.height);
        _videoLayer.frame = CGRectMake(0, 0, _assetTrack.naturalSize.width, _assetTrack.naturalSize.height);
        
        if (_bgLayer) {
            [_parentLayer addSublayer:_bgLayer];
        }
        [_parentLayer addSublayer:_videoLayer];
        for (CALayer * sticker in _layersArray) {
            [_parentLayer addSublayer:sticker];
        }
        
        _videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:_videoLayer inLayer:_parentLayer];
    }
    
    return _videoComposition;
}

- (void)addBgLayer:(CALayer *)layer
{
    _bgLayer = layer;
}

- (void)addLayers:(NSArray <CALayer *> *)layers
{
    [_layersArray addObjectsFromArray:layers];
}

@end
