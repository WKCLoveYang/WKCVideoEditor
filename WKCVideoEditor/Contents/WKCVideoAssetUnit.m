//
//  WKCAssetUnit.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoAssetUnit.h"


@interface WKCVideoAssetUnit()

@property (nonatomic, strong) AVAsset * asset;
@property (nonatomic, strong) AVAssetTrack * videoTrack;
@property (nonatomic, strong) AVAssetTrack * audioTrack;

@end

@implementation WKCVideoAssetUnit

- (instancetype)initWithContent:(id)content
{
    if (self = [super init]) {
        if ([content isKindOfClass:[AVAsset class]]) {
            _asset = content;
        } else {
            _asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:content]];
        }
        
        _videoTrack = [self getAssetVideoTrackWithAsset:_asset];
        _audioTrack = [self getAssetAudioTrackWithAsset:_asset];
    }
    
    return self;
}

- (CMTime)start
{
    return kCMTimeZero;
}

- (CMTime)duration
{
    return _asset.duration;
}

- (CMTimeRange)range
{
    return CMTimeRangeMake([self start], [self duration]);
}



- (AVAssetTrack *)getAssetVideoTrackWithAsset:(AVAsset *)asset
{
    NSArray <AVAssetTrack *>* videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    if (!videoTracks || videoTracks.count == 0) {
        NSLog(@"...... origin video is nil!!!");
        return nil;
    }
    
    return videoTracks.firstObject;
}

- (AVAssetTrack *)getAssetAudioTrackWithAsset:(AVAsset *)asset
{
    NSArray <AVAssetTrack *>* audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    if (!audioTracks || audioTracks.count == 0) {
        NSLog(@"...... origin audio is nil!!!");
        return nil;
    }
    
    return audioTracks.firstObject;
}

@end
