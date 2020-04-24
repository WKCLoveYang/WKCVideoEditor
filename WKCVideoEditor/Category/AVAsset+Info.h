//
//  AVAsset+Info.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AVAsset (Info)

- (CGSize)videoSize;
- (int)videoDuration;
- (float)framePerSecond;
- (NSArray <UIImage *>*)allFrames;
- (NSArray <UIImage *>*)thumbFrames;

@end

