//
//  WKCVideoStickerLayer.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "WKCVideoStickerView.h"

@interface WKCVideoStickerLayer : CALayer


- (instancetype)initWithStickerView:(WKCVideoStickerView *)stickerView
                    videoNatureSize:(CGSize)videoNatureSize
                          beginTime:(NSTimeInterval)beginTime
                           duration:(NSTimeInterval)duration;

@end

