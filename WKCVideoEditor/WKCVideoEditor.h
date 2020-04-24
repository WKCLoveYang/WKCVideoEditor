//
//  WKCVideoEditor.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCVideoAssetUnit.h"
#import "WKCVideoCompositionUnit.h"
#import "WKCVideoLayerUnit.h"
#import "WKCVideoModelTransformUnit.h"
#import "WKCVideoExportUnit.h"
#import "NSString+AssetInfo.h"
#import "AVAsset+Info.h"


@interface WKCVideoEditor : NSObject


/// when create image to video , should make the imageBg lightEffect, default is no.
@property (nonatomic, assign) BOOL createShouldImageBgLightEffect;

/// when create image to video, the image resize type, default is scale
@property (nonatomic, assign) WKCVideoResizeType createImageResizeType;

/// when create video, set the video picture quality, default is WKCVideoQualitySuperHigh.
@property (nonatomic, assign) WKCVideoQuality createVideoQuality;

/// when create video, and quality is custom, use the custom size.
@property (nonatomic, assign) CGSize createCustomVideoSize;

/// when create video, and content has image, set an image's duration, default is 5s.
@property (nonatomic, assign) int createPerImageDuration;




/// when you insert audio into video, if the insert audio replace origin audio( if origin audio do exist)?, default is no, that means, there will be two kinds of audios mixed togeter in the video.
@property (nonatomic, assign) BOOL insertAudioShouldReplaceOrigin;


/// shared instance
+ (WKCVideoEditor *)sharedEditor;


/// create video with contents, contents could be UIImage、 videoPath or AVAsset, and the counts are not limit, whent you add images, you can setup up's propertys to chontrol paramarers.
/// @param contents contents
/// @param savePath the savePath of your created video
/// @param completion the completion callback
- (void)createVideoWithContents:(NSArray <id>*)contents
                     atSavePath:(NSString *)savePath
                     completion:(WKCVideoCompletionBlock)completion;


/// merge videos togeter, contents could be videoPath or AVAsset
/// @param contents contents
/// @param savePath the savePath of your created video
/// @param completion the completion callback
- (void)mergeVideosWithContents:(NSArray <id>*)contents
                    atSavewPath:(NSString *)savePath
                     completion:(WKCVideoCompletionBlock)completion;


/// cut video, get range of it. contents could be videoPath or AVAsset
/// @param content contents
/// @param savePath the savePath of your created video
/// @param startTime the cut start time
/// @param endTime the cut end time
/// @param completion the completion callback
- (void)rangeOfVideoAtContent:(id)content
                   atSavePath:(NSString *)savePath
                    startTime:(NSTimeInterval)startTime
                      endTime:(NSTimeInterval)endTime
                   completion:(WKCVideoCompletionBlock)completion;


/// cut video, get range of it. contents could be videoPath or AVAsset. And also insert backgroundLayer or layers into video.
/// @param content contents
/// @param savePath the savePath of your created video
/// @param startTime the cut start time
/// @param endTime the cut end time
/// @param bgLayer backgroundLayer
/// @param layers layers
/// @param completion the completion callback
- (void)rangeOfVideoAtContent:(id)content
                   atSavePath:(NSString *)savePath
                    startTime:(NSTimeInterval)startTime
                      endTime:(NSTimeInterval)endTime
                      bgLayer:(CALayer *)bgLayer
                       layers:(NSArray <CALayer *>*)layers
                   completion:(WKCVideoCompletionBlock)completion;


/// insert audio into video
/// @param audio new audio
/// @param originVideo origin video
/// @param savePath the savePath of your created video
/// @param completion the completion callback
- (void)insertAudioWithAudio:(id)audio
               atOriginVideo:(id)originVideo
                  atSavePath:(NSString *)savePath
                  completion:(WKCVideoCompletionBlock)completion;


/// insert audio into video, and also insert backgroundLayer or some layers into video. Also you can control the start and end time. But the start or end time does not work for backgroundLayer or layers. BackgroundLayer or layers work in all the video time.
/// @param audio new audio
/// @param originVideo origin video
/// @param savePath the savePath of your created video
/// @param startTime start time
/// @param endTime end time
/// @param bgLayer backgroundLayer
/// @param layers layers
/// @param completion the completion callback
- (void)insertAudioWithAudio:(id)audio
               atOriginVideo:(id)originVideo
                  atSavePath:(NSString *)savePath
                   startTime:(NSTimeInterval)startTime
                     endTime:(NSTimeInterval)endTime
                     bgLayer:(CALayer *)bgLayer
                      layers:(NSArray <CALayer *>*)layers
                  completion:(WKCVideoCompletionBlock)completion;


/// insert layers into video
/// @param originVideo origin video
/// @param savePath the savePath of your created video
/// @param bgLayer backgroundLayer
/// @param layers layers
/// @param completion the completion callback
- (void)insertLayersWithOriginVideo:(id)originVideo
                         atSavePath:(NSString *)savePath
                            bgLayer:(CALayer *)bgLayer
                             layers:(NSArray <CALayer *>*)layers
                         completion:(WKCVideoCompletionBlock)completion;


@end

