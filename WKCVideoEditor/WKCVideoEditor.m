//
//  WKCVideoEditor.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoEditor.h"
#import "UIImage+category.h"


@interface WKCVideoEditor()

@property (nonatomic, strong) NSString * savePath;
@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *adaptor;

@property (nonatomic, assign) WKCVideoExportStatus currentStatus;

@end

@implementation WKCVideoEditor

+ (WKCVideoEditor *)sharedEditor
{
    static WKCVideoEditor * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCVideoEditor alloc] init];
        instance.createShouldImageBgLightEffect = NO;
        instance.createVideoQuality = WKCVideoQualitySuperHigh;
        instance.createCustomVideoSize = CGSizeZero;
        instance.createPerImageDuration = 5;
        instance.createImageResizeType = WKCVideoResizeTypeScale;
    });
    
    return instance;
}

- (AVAssetWriter *)videoWriter
{
    if (!_videoWriter) {
        NSURL * fileUrl = [NSURL fileURLWithPath:_savePath];
        _videoWriter = [[AVAssetWriter alloc] initWithURL:fileUrl fileType:AVFileTypeMPEG4 error:nil];
    }
    
    return _videoWriter;
}



// 初始化基础配置
- (void)setupConfignWithVideoSize:(CGSize)videoSize
                       completion:(void(^)(void))completion
{
    if ([NSFileManager.defaultManager fileExistsAtPath:_savePath]) {
        BOOL hasRemoved = [NSFileManager.defaultManager removeItemAtPath:_savePath
                                                 error:nil];
        if (hasRemoved) {
            [self setupWriteInputWithVideoSize:videoSize
                                    completion:completion];
            
            return;
        }
    }
    
    [self setupWriteInputWithVideoSize:videoSize
                            completion:completion];
}


- (void)setupWriteInputWithVideoSize:(CGSize)videoSize
                          completion:(void(^)(void))completion
{
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:videoSize.width * videoSize.height], AVVideoAverageBitRateKey, nil];
    
    NSDictionary *videoSettings = @{
        AVVideoCodecKey: AVVideoCodecTypeH264,
        AVVideoWidthKey: @(videoSize.width),
        AVVideoHeightKey: @(videoSize.height),
        AVVideoCompressionPropertiesKey: videoCompressionProps};
    
    _videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    _videoWriterInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    _adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoWriterInput sourcePixelBufferAttributes:bufferAttributes];
    
    [self.videoWriter addInput:_videoWriterInput];
    [self.videoWriter startWriting];
    [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    if (completion) {
        completion();
    }
}



- (void)createVideoWithContents:(NSArray <id>*)contents
                     atSavePath:(NSString *)savePath
                     completion:(WKCVideoCompletionBlock)completion
{
    if (!contents || contents.count == 0) {
        NSLog(@"######## error, contents is nil ########");
        if (completion) {
            completion(WKCVideoExportStatusExportedFailed);
        }
        return;
    }
    
    _savePath = savePath;
    
    WKCVideoModelTransformUnit * transformUnit = [[WKCVideoModelTransformUnit alloc] initWithContents:contents imageDuration:_createPerImageDuration quality:_createVideoQuality customSize:_createCustomVideoSize];
    transformUnit.shouldImageBgEffect = _createShouldImageBgLightEffect;
    transformUnit.imageResizeType = _createImageResizeType;

    if (!transformUnit.hasImage) {
        [self mergeVideosWithContents:contents
                          atSavewPath:savePath
                           completion:completion];
        return;
    }
    
    int duration = transformUnit.totalDuration;
    NSArray <WKCVideoModel *> * models = transformUnit.models;
    
    __weak typeof(self)weakSelf = self;
    int __block frame = 0;
    
    [self setupConfignWithVideoSize:transformUnit.videoSize
                         completion:^{
        [weakSelf.videoWriterInput requestMediaDataWhenReadyOnQueue:dispatch_get_main_queue()
                                                 usingBlock:^{
            while ([weakSelf.videoWriterInput isReadyForMoreMediaData]) {
                if (frame >= duration * 30) {
                    [weakSelf.videoWriterInput markAsFinished];
                    [weakSelf.videoWriter finishWritingWithCompletionHandler:^{
                        weakSelf.videoWriter = nil;
                        weakSelf.videoWriterInput = nil;
                        weakSelf.adaptor = nil;
                        
                        [weakSelf writeVideoIntoImageVideoWithTransformUnit:transformUnit atSavePath:savePath completion:completion];
                    }];
                   break;
                }
                
                UIImage * insertImage = nil;
                
                for (int i = 0; i < models.count; i ++) {
                    WKCVideoModel * model = models[i];
                    if (frame >= model.startTime * 30 && frame < model.endTime * 30 && model.type == WKCContentTypeImage) {
                        insertImage = model.content;
                        break;
                    }
                }
                
                if (insertImage) {
                    CVPixelBufferRef imageBuffer = [insertImage pixelBuffer];
                    [weakSelf.adaptor appendPixelBuffer:imageBuffer
                                   withPresentationTime:CMTimeMake(frame,30)];
                }
                
                ++frame;
            }
        }];
    }];
}

- (void)writeVideoIntoImageVideoWithTransformUnit:(WKCVideoModelTransformUnit *)transformUnit
                                       atSavePath:(NSString *)savePath
                                       completion:(WKCVideoCompletionBlock)completion
{
    if (!transformUnit.hasVideo) {
        if (completion) {
            completion(WKCVideoExportStatusExportedSuccess);
        }
        return;
    }
    
    if (_currentStatus == WKCVideoExportStatusExporting) {
        NSLog(@"######## error, there is a task is exporting, please wait unit it completed ########");
        if (completion) {
            completion(WKCVideoExportStatusExporting);
        }
        return;
    }
    
    _currentStatus = WKCVideoExportStatusExporting;
    
    WKCVideoAssetUnit * assetUnit = [[WKCVideoAssetUnit alloc] initWithContent:savePath];
    
    WKCVideoCompositionUnit * compositionUnit = [[WKCVideoCompositionUnit alloc] init];
    
    AVMutableCompositionTrack * videoTrack = [compositionUnit createAVideoCompostionTrack];
    videoTrack.preferredTransform = assetUnit.videoTrack.preferredTransform;
    
    AVMutableCompositionTrack * audioTrack = nil;
    
    for (WKCVideoModel * model in transformUnit.models) {
        if (model.type == WKCContentTypeImage) {
            CMTime start = CMTimeMakeWithSeconds(model.startTime, 30);
            CMTime duration = CMTimeMakeWithSeconds(model.duration, 30);
            CMTimeRange range = CMTimeRangeMake(start, duration);
            [videoTrack insertTimeRange:range
                                ofTrack:assetUnit.videoTrack
                                 atTime:start
                                  error:nil];
        } else {
            WKCVideoAssetUnit * insertVideoAssetUnit = [[WKCVideoAssetUnit alloc] initWithContent:model.content];
            
            CMTime start = CMTimeMakeWithSeconds(0, 30);
            CMTime duration = CMTimeMakeWithSeconds(model.duration, 30);
            CMTimeRange range = CMTimeRangeMake(start, duration);
            CMTime atTime = CMTimeMakeWithSeconds(model.startTime, 30);
            
            if (insertVideoAssetUnit.videoTrack) {
                [videoTrack insertTimeRange:range
                                    ofTrack:insertVideoAssetUnit.videoTrack
                                     atTime:atTime
                                      error:nil];
            }
            
            if (insertVideoAssetUnit.audioTrack) {
                if (!audioTrack) {
                    audioTrack = [compositionUnit createAAudioCompostionTrack];
                }
                
                [audioTrack insertTimeRange:range
                                    ofTrack:insertVideoAssetUnit.audioTrack
                                     atTime:atTime
                                      error:nil];
            }
        }
    }
    
    WKCVideoExportUnit * exportUnit = [[WKCVideoExportUnit alloc] initWithCompositionContext:compositionUnit.composition savePath:savePath range:kCMTimeRangeZero audioMix:nil videoComposition:nil];
    
    [exportUnit exportWithCompletion:^(WKCVideoExportStatus status) {
        self.currentStatus = WKCVideoExportStatusCommon;
        if (completion) {
            completion(status);
        }
    }];
}










- (void)mergeVideosWithContents:(NSArray <id>*)contents
                    atSavewPath:(NSString *)savePath
                     completion:(WKCVideoCompletionBlock)completion
{
    if (_currentStatus == WKCVideoExportStatusExporting) {
        NSLog(@"######## error, there is a task is exporting, please wait unit it completed ########");
        if (completion) {
            completion(WKCVideoExportStatusExporting);
        }
        return;
    }
    
    if (!contents || contents.count == 0) {
        NSLog(@"######## error, contents is nil ########");
        if (completion) {
            completion(WKCVideoExportStatusExportedFailed);
        }
        return;
    }
    
    _currentStatus = WKCVideoExportStatusExporting;
    
    WKCVideoCompositionUnit * compostionUnit = [[WKCVideoCompositionUnit alloc] init];
    AVMutableCompositionTrack * videoTrack = nil;
    AVMutableCompositionTrack * audioTrack = nil;
    
    CMTime totalDuration = kCMTimeZero;
    
    for (int i = 0; i < contents.count; i ++) {
        
        CMTime duration = kCMTimeZero;
        CMTimeRange range = kCMTimeRangeZero;
        
        WKCVideoAssetUnit * assetUnit = [[WKCVideoAssetUnit alloc] initWithContent:contents[i]];
        
        if (assetUnit.videoTrack) {
            if (!videoTrack) {
                videoTrack = [compostionUnit createAVideoCompostionTrack];
            }
            
            duration = assetUnit.videoTrack.timeRange.duration;
            range = CMTimeRangeMake(kCMTimeZero, duration);
            
            [videoTrack insertTimeRange:range
                                ofTrack:assetUnit.videoTrack
                                 atTime:totalDuration
                                  error:nil];
            
            // keep video direction
            videoTrack.preferredTransform = assetUnit.videoTrack.preferredTransform;
        }
        
        if (assetUnit.audioTrack) {
            if (!audioTrack) {
                audioTrack = [compostionUnit createAAudioCompostionTrack];
            }
            
            if (CMTimeRangeEqual(range, kCMTimeRangeZero)) {
                duration = assetUnit.audioTrack.timeRange.duration;
                range = CMTimeRangeMake(kCMTimeZero, duration);
            }
            
            [audioTrack insertTimeRange:range
                                ofTrack:assetUnit.audioTrack
                                 atTime:totalDuration
                                  error:nil];
        }
    
        totalDuration = CMTimeAdd(totalDuration, duration);
    }
    
    WKCVideoExportUnit * exportUnit = [[WKCVideoExportUnit alloc] initWithCompositionContext:compostionUnit.composition savePath:savePath range:kCMTimeRangeZero audioMix:nil videoComposition:nil];
    
    [exportUnit exportWithCompletion:^(WKCVideoExportStatus status) {
        self.currentStatus = WKCVideoExportStatusCommon;
        if (completion) {
            completion(status);
        }
    }];
}




- (void)rangeOfVideoAtContent:(id)content
                   atSavePath:(NSString *)savePath
                    startTime:(NSTimeInterval)startTime
                      endTime:(NSTimeInterval)endTime
                   completion:(WKCVideoCompletionBlock)completion
{
    [self rangeOfVideoAtContent:content
                     atSavePath:savePath
                      startTime:startTime
                        endTime:endTime
                        bgLayer:nil
                         layers:nil
                     completion:completion];
}

- (void)rangeOfVideoAtContent:(id)content
                   atSavePath:(NSString *)savePath
                    startTime:(NSTimeInterval)startTime
                      endTime:(NSTimeInterval)endTime
                      bgLayer:(CALayer *)bgLayer
                       layers:(NSArray <CALayer *>*)layers
                   completion:(WKCVideoCompletionBlock)completion
{
    if (_currentStatus == WKCVideoExportStatusExporting) {
        NSLog(@"######## error, there is a task is exporting, please wait unit it completed ########");
        if (completion) {
            completion(WKCVideoExportStatusExporting);
        }
        return;
    }
    
    if (!content) {
        NSLog(@"######## error, origin video is nil ########");
        if (completion) {
            completion(WKCVideoExportStatusExportedFailed);
        }
        return;
    }
    
    _currentStatus = WKCVideoExportStatusExporting;
    
    WKCVideoAssetUnit * assetUnit = [[WKCVideoAssetUnit alloc] initWithContent:content];
    
    WKCVideoCompositionUnit * compositionUnit = [[WKCVideoCompositionUnit alloc] init];
    
    AVMutableCompositionTrack * videoTrack = nil;
    AVMutableCompositionTrack * audioTrack = nil;
    
    if (assetUnit.videoTrack) {
        videoTrack = [compositionUnit createAVideoCompostionTrack];
        videoTrack.preferredTransform = assetUnit.videoTrack.preferredTransform;
        [videoTrack insertTimeRange:assetUnit.range
                            ofTrack:assetUnit.videoTrack
                             atTime:assetUnit.start
                              error:nil];
    }
    
    if (assetUnit.audioTrack) {
        audioTrack = [compositionUnit createAAudioCompostionTrack];
        [audioTrack insertTimeRange:assetUnit.range
                            ofTrack:assetUnit.audioTrack
                             atTime:assetUnit.start
                              error:nil];
    }
    
    CMTime cutStart = CMTimeMakeWithSeconds(startTime, assetUnit.duration.timescale);
    CMTime cutDuration = CMTimeMakeWithSeconds(endTime - startTime, assetUnit.duration.timescale);
    CMTimeRange cutRange = CMTimeRangeMake(cutStart, cutDuration);
    
    WKCVideoLayerUnit * layerUnit = [[WKCVideoLayerUnit alloc] initWithAsset:assetUnit.asset assetTrack:assetUnit.videoTrack intoVideoTrack:videoTrack];
    if (bgLayer) {
        [layerUnit addBgLayer:bgLayer];
    }
    if (layers && layers.count != 0) {
        [layerUnit addLayers:layers];
    }
    
    WKCVideoExportUnit * exportUnit = [[WKCVideoExportUnit alloc] initWithCompositionContext:compositionUnit.composition savePath:savePath range:cutRange audioMix:nil videoComposition:layerUnit.videoComposition];
    
    [exportUnit exportWithCompletion:^(WKCVideoExportStatus status) {
        self.currentStatus = WKCVideoExportStatusCommon;
        if (completion) {
            completion(status);
        }
    }];
}












- (void)insertAudioWithAudio:(id)audio
               atOriginVideo:(id)originVideo
                  atSavePath:(NSString *)savePath
                  completion:(WKCVideoCompletionBlock)completion
{
    NSTimeInterval startTime = 0;
    NSTimeInterval endTime = [originVideo videoDuration];
    [self insertAudioWithAudio:audio
                 atOriginVideo:originVideo
                    atSavePath:savePath
                     startTime:startTime
                       endTime:endTime
                       bgLayer:nil
                        layers:nil
                    completion:completion];
}


- (void)insertLayersWithOriginVideo:(id)originVideo
                         atSavePath:(NSString *)savePath
                            bgLayer:(CALayer *)bgLayer
                             layers:(NSArray <CALayer *>*)layers
                         completion:(WKCVideoCompletionBlock)completion
{
    [self insertAudioWithAudio:nil
                 atOriginVideo:originVideo
                    atSavePath:savePath
                     startTime:0
                       endTime:0
                       bgLayer:bgLayer
                        layers:layers
                    completion:completion];
}

- (void)insertAudioWithAudio:(id)audio
               atOriginVideo:(id)originVideo
                  atSavePath:(NSString *)savePath
                   startTime:(NSTimeInterval)startTime
                     endTime:(NSTimeInterval)endTime
                     bgLayer:(CALayer *)bgLayer
                      layers:(NSArray <CALayer *>*)layers
                  completion:(WKCVideoCompletionBlock)completion
{
    if (_currentStatus == WKCVideoExportStatusExporting) {
        NSLog(@"######## error, there is a task is exporting, please wait unit it completed ########");
        if (completion) {
            completion(WKCVideoExportStatusExporting);
        }
        return;
    }
    
    if (!originVideo) {
        NSLog(@"######## error, origin video is nil ########");
        if (completion) {
            completion(WKCVideoExportStatusExportedFailed);
        }
        return;
    }
    
    _currentStatus = WKCVideoExportStatusExporting;
    
    WKCVideoAssetUnit * originVideoAssetUnit = [[WKCVideoAssetUnit alloc] initWithContent:originVideo];
    
    WKCVideoCompositionUnit * compositionUnit = [[WKCVideoCompositionUnit alloc] init];
    AVMutableCompositionTrack * videoTrack = nil;
    AVMutableCompositionTrack * audioTrack = nil;
    
    if (originVideoAssetUnit.videoTrack) {
        videoTrack = [compositionUnit createAVideoCompostionTrack];
        videoTrack.preferredTransform = originVideoAssetUnit.videoTrack.preferredTransform;
        [videoTrack insertTimeRange:originVideoAssetUnit.range
                            ofTrack:originVideoAssetUnit.videoTrack
                             atTime:originVideoAssetUnit.start
                              error:nil];
    }
    
    if (originVideoAssetUnit.audioTrack) {
        audioTrack = [compositionUnit createAAudioCompostionTrack];
        [audioTrack insertTimeRange:originVideoAssetUnit.range
                            ofTrack:originVideoAssetUnit.audioTrack
                             atTime:originVideoAssetUnit.start
                              error:nil];
    }
    
    if (audio) {
        WKCVideoAssetUnit * insertAssetUnit = [[WKCVideoAssetUnit alloc] initWithContent:audio];
        
        CMTime cutDuration = CMTimeMakeWithSeconds(endTime - startTime, originVideoAssetUnit.duration.timescale);
        CMTimeRange cutRange = CMTimeRangeMake(kCMTimeZero, cutDuration);
        CMTime atTime = CMTimeMakeWithSeconds(startTime, originVideoAssetUnit.duration.timescale);
        
        if (insertAssetUnit.videoTrack) {
            [videoTrack insertTimeRange:cutRange
                                ofTrack:insertAssetUnit.videoTrack
                                 atTime:atTime
                                  error:nil];
        }
        
        if (insertAssetUnit.audioTrack) {
            if (_insertAudioShouldReplaceOrigin) {
                if (!audioTrack) {
                    audioTrack = [compositionUnit createAAudioCompostionTrack];
                }
                [audioTrack insertTimeRange:cutRange
                                    ofTrack:insertAssetUnit.audioTrack
                                     atTime:atTime
                                      error:nil];
            } else {
                AVMutableCompositionTrack * insertAudioTrack = [compositionUnit createAAudioCompostionTrack];
                [insertAudioTrack insertTimeRange:cutRange
                                          ofTrack:insertAssetUnit.audioTrack
                                           atTime:atTime
                                            error:nil];
            }
        }
    }
    
    WKCVideoLayerUnit * layerUnit = [[WKCVideoLayerUnit alloc] initWithAsset:originVideoAssetUnit.asset assetTrack:originVideoAssetUnit.videoTrack intoVideoTrack:videoTrack];
    if (bgLayer) {
        [layerUnit addBgLayer:bgLayer];
    }
    if (layers && layers.count != 0) {
        [layerUnit addLayers:layers];
    }
    
    WKCVideoExportUnit * exportUnit = [[WKCVideoExportUnit alloc] initWithCompositionContext:compositionUnit.composition savePath:savePath range:kCMTimeRangeZero audioMix:nil videoComposition:layerUnit.videoComposition];
    
    [exportUnit exportWithCompletion:^(WKCVideoExportStatus status) {
        self.currentStatus = WKCVideoExportStatusCommon;
        if (completion) {
            completion(status);
        }
    }];
}







@end
