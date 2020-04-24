//
//  WKCVideoExportUnit.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoExportUnit.h"

@interface WKCVideoExportUnit()

@property (nonatomic, strong) AVMutableComposition * compositionContext;
@property (nonatomic, strong) NSString * savePath;
@property (nonatomic, assign) CMTimeRange range;
@property (nonatomic, strong) AVAudioMix * audioMix;
@property (nonatomic, strong) AVVideoComposition * videoComposition;

@end

@implementation WKCVideoExportUnit

- (instancetype)initWithCompositionContext:(AVMutableComposition *)compositionContext
                                  savePath:(NSString *)savePath
                                     range:(CMTimeRange)range
                                  audioMix:(AVAudioMix *)audioMix
                          videoComposition:(AVVideoComposition *)videoComposition
{
    if (self = [super init]) {
        _compositionContext = compositionContext;
        _savePath = savePath;
        _range = range;
        _audioMix = audioMix;
        _videoComposition  = videoComposition;
    }
    
    return self;
}

- (void)exportWithCompletion:(WKCVideoCompletionBlock)completion
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:_savePath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:_savePath error:nil]) {
            [self innerExportWithCompletion:completion];
        }
        return;
    }
    
    [self innerExportWithCompletion:completion];
}

- (void)innerExportWithCompletion:(WKCVideoCompletionBlock)completion
{
    AVAssetExportSession *avAssetExportSession = [[AVAssetExportSession alloc] initWithAsset:_compositionContext
                                                                                  presetName:AVAssetExportPresetHighestQuality];
    if (_videoComposition) {
        avAssetExportSession.videoComposition = _videoComposition;
    }
    if (_audioMix) {
        avAssetExportSession.audioMix = _audioMix;
    }
    if (!CMTimeRangeEqual(_range, kCMTimeRangeZero)) {
        avAssetExportSession.timeRange = _range;
    }
    
    avAssetExportSession.outputURL = [NSURL fileURLWithPath:_savePath];
    avAssetExportSession.outputFileType = AVFileTypeMPEG4;
    avAssetExportSession.shouldOptimizeForNetworkUse = YES;
    [avAssetExportSession exportAsynchronouslyWithCompletionHandler:^{
        WKCVideoExportStatus status = avAssetExportSession.status == AVAssetExportSessionStatusCompleted ? WKCVideoExportStatusExportedSuccess : WKCVideoExportStatusExportedFailed;
        if (completion) {
            completion(status);
        }
    }];
}

@end
