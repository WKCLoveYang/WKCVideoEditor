//
//  UIImage+category.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "UIImage+category.h"
#import "UIImageEffects.h"

@implementation UIImage (category)

- (CVPixelBufferRef)pixelBuffer
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    CGFloat frameWidth = self.size.width;
    CGFloat frameHeight = self.size.height;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameWidth,
                                                 frameHeight, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0, 0, frameWidth, frameHeight), self.CGImage);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (UIImage *)sizeToFit:(CGSize)size
                  type:(WKCVideoResizeType)type
         shoudBgEffect:(BOOL)shoudBgEffect
{
    CGRect destRect = [self destRectWithSize:size
                                        type:type];
    
    UIImage *img = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    if (shoudBgEffect) {
        UIImage * bgImage = [UIImageEffects imageByApplyingLightEffectToImage:self];
        [bgImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    [self drawInRect:destRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (CGRect)destRectWithSize:(CGSize)size
                      type:(WKCVideoResizeType)type
{
    float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth = size.width;
    float targetHeight = size.height;

    CGRect destRect = CGRectZero;
    if (type == WKCVideoResizeTypeScale) {
        if (sourceHeight / sourceWidth > targetHeight / targetWidth) {
            destRect.size.height = targetHeight;
            destRect.size.width = targetHeight * sourceWidth / sourceHeight;
            destRect.origin.x = (targetWidth - destRect.size.width) / 2.0;
            destRect.origin.y = 0;
        } else {
            destRect.size.width = targetWidth;
            destRect.size.height = targetWidth * sourceHeight / sourceWidth;
            destRect.origin.x = 0;
            destRect.origin.y = (targetHeight - destRect.size.height) / 2.0;
        }
    } else {
        if (sourceHeight / sourceWidth > targetHeight / targetWidth) {
            destRect.size.width = targetWidth;
            destRect.size.height = targetWidth * sourceHeight / sourceWidth;
            destRect.origin.x = 0;
            destRect.origin.y = (targetHeight - destRect.size.height) / 2.0;
        } else {
            destRect.size.height = targetHeight;
            destRect.size.width = targetHeight * sourceWidth / sourceHeight;
            destRect.origin.x = (targetWidth - destRect.size.width) / 2.0;
            destRect.origin.y = 0;
        }
    }
    
    return destRect;
}

@end
