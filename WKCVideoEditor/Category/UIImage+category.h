//
//  UIImage+category.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WKCVideoResizeType) {
    WKCVideoResizeTypeScale   = 0, // 保持原图比例
    WKCVideoResizeTypeCenter  = 1  // 居中
};


@interface UIImage (category)

- (CVPixelBufferRef)pixelBuffer;

- (UIImage *)sizeToFit:(CGSize)size
                  type:(WKCVideoResizeType)type
         shoudBgEffect:(BOOL)shoudBgEffect;

@end

