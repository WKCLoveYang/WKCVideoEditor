//
//  WKCVideoPictureManager.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoPictureManager.h"

@implementation WKCVideoPictureManager

+ (WKCVideoPictureManager *)shared
{
    static WKCVideoPictureManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKCVideoPictureManager alloc] init];
    });
    
    return instance;
}

- (CGAffineTransform)transformPicktureWithVideoNatureSize:(CGSize)natureSize
                                              presentSize:(CGSize)presentSize
{
    CGFloat natureWidth = natureSize.width;
    CGFloat natureHeight = natureSize.height;
    
    CGFloat videoWidth = presentSize.width;
    CGFloat videoHeight = presentSize.height;
    
    if (natureHeight / natureWidth == videoHeight / videoWidth) {
        return CGAffineTransformIdentity;
    }
    
    if (natureHeight / natureWidth > videoHeight / videoWidth) {
        CGFloat newHeight = videoHeight;
        CGFloat newWidth = videoHeight * natureWidth / natureHeight;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(newWidth / natureWidth, newHeight / natureHeight);
        CGAffineTransform centerTransform = CGAffineTransformMakeTranslation((videoWidth - newWidth) / 2.0, 0);
        return CGAffineTransformConcat(scaleTransform, centerTransform);
    }
    
    CGFloat newWidth = videoWidth;
    CGFloat newHeight = videoWidth * natureHeight / natureWidth;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(newWidth / natureWidth, newHeight / natureHeight);
    CGAffineTransform centerTransform = CGAffineTransformMakeTranslation(0, (videoHeight - newHeight) / 2.0);
    return CGAffineTransformConcat(scaleTransform, centerTransform);
}

@end
