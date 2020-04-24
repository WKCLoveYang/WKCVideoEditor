//
//  NSString+AssetInfo.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "NSString+AssetInfo.h"

@implementation NSString (AssetInfo)

- (AVAsset *)transformToAsset
{
    return [AVAsset assetWithURL:[NSURL fileURLWithPath:self]];
}

- (CGSize)videoSize
{
    return [[self transformToAsset] videoSize];
}

- (int)videoDuration
{
    return [[self transformToAsset] videoDuration];
}

- (float)framePerSecond
{
    return [[self transformToAsset] framePerSecond];
}

- (NSArray <UIImage *>*)allFrames
{
    return [[self transformToAsset] allFrames];
}

- (NSArray <UIImage *>*)thumbFrames
{
    return [[self transformToAsset] thumbFrames];
}


@end
