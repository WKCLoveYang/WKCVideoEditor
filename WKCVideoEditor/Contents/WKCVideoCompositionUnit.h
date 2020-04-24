//
//  WKCCompositionUnit.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WKCVideoCompositionUnit : NSObject

@property (nonatomic, strong, readonly) AVMutableComposition * composition;

/// create a video compostion track
- (AVMutableCompositionTrack *)createAVideoCompostionTrack;
/// create a audio compostion track
- (AVMutableCompositionTrack *)createAAudioCompostionTrack;

@end

