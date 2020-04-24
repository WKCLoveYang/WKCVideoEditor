//
//  NSString+AssetInfo.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVAsset+Info.h"

@interface NSString (AssetInfo)

- (CGSize)videoSize;
- (int)videoDuration;
- (float)framePerSecond;
- (NSArray <UIImage *>*)allFrames;
- (NSArray <UIImage *>*)thumbFrames;

@end

