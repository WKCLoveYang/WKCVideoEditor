//
//  AVAsset+Info.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "AVAsset+Info.h"

@implementation AVAsset (Info)

- (CGSize)videoSize
{
    NSArray * array = self.tracks;
    CGSize videoSize = CGSizeZero;
    
    for (AVAssetTrack * track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    
    return videoSize;
}

- (int)videoDuration
{
    CMTime time = [self duration];
    return ceil(time.value / time.timescale);
}

- (float)framePerSecond
{
    NSArray * array = self.tracks;
    float frameRate = 0;
    
    for (AVAssetTrack * track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            frameRate = track.nominalFrameRate;
        }
    }
    
    return frameRate;
}

- (NSArray <UIImage *>*)allFrames
{
    AVAssetImageGenerator * generator = [[AVAssetImageGenerator alloc] initWithAsset:self];
      generator.appliesPreferredTrackTransform = YES;
      generator.requestedTimeToleranceBefore = kCMTimeZero;
      generator.requestedTimeToleranceAfter = kCMTimeZero;
      NSMutableArray * array = [NSMutableArray array];
      int framePerSecond = [self framePerSecond];
      int duration = [self videoDuration];
      for (int i = 0; i < duration * framePerSecond; i ++) {
          @autoreleasepool {
              CMTime time = CMTimeMake(i, framePerSecond);
              NSError *err;
              CMTime actualTime;
              CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
              UIImage * geneatedImage = [[UIImage alloc] initWithCGImage:image];
              [array addObject:geneatedImage];
              CGImageRelease(image);
          }
      }
      
      return array;
}

- (NSArray <UIImage *>*)thumbFrames
{
    AVAssetImageGenerator * generator = [[AVAssetImageGenerator alloc] initWithAsset:self];
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    NSMutableArray * array = [NSMutableArray array];
    int frameperSecond = [self framePerSecond];
    int duration = [self videoDuration];
    int num = ceil(frameperSecond * duration / 10.0);
    // 最长30s
    for (int i = 0; i < duration * frameperSecond; i ++) {
        @autoreleasepool {
            if (i % num == 0) {
                CMTime time = CMTimeMake(i, frameperSecond);
                NSError *err;
                CMTime actualTime;
                CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
                UIImage * geneatedImage = [[UIImage alloc] initWithCGImage:image];
                if (geneatedImage) {
                    [array addObject:geneatedImage];
                } else {
                    [array addObject:[self.class imageWithColor:[UIColor blackColor]]];
                }
                
                CGImageRelease(image);
            }
        }
    }
    
    return array;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
