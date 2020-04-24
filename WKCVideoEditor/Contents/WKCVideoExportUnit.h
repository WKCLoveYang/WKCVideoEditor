//
//  WKCVideoExportUnit.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, WKCVideoExportStatus) {
    WKCVideoExportStatusCommon            = 0,
    WKCVideoExportStatusExportedFailed    = 1,
    WKCVideoExportStatusExportedSuccess   = 2,
    WKCVideoExportStatusExporting         = 3
};

typedef void(^WKCVideoCompletionBlock)(WKCVideoExportStatus status);

@interface WKCVideoExportUnit : NSObject

- (instancetype)initWithCompositionContext:(AVMutableComposition *)compositionContext
                                  savePath:(NSString *)savePath
                                     range:(CMTimeRange)range
                                  audioMix:(AVAudioMix *)audioMix
                          videoComposition:(AVVideoComposition *)videoComposition;


- (void)exportWithCompletion:(WKCVideoCompletionBlock)completion;

@end

