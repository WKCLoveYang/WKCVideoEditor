//
//  CAKeyframeAnimation+Setup.m
//  ABDC
//
//  Created by wkcloveYang on 2020/3/18.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "CAKeyframeAnimation+Setup.h"


@interface CAPropertyAnimation(KeyPath)

+ (NSDictionary *)keyPathMap;

@end

@implementation CAPropertyAnimation(KeyPath)

+ (NSDictionary *)keyPathMap
{
   return @{
       @(KAnimationTypePosition)       : @"position",
       @(KAnimationTypePositionX)      : @"position.x",
       @(KAnimationTypePositionY)      : @"position.y",
       @(KAnimationTypeSize)           : @"bounds.size",
       @(KAnimationTypeWidth)          : @"bounds.size.width",
       @(KAnimationTypeHeight)         : @"bounds.size.height",
       @(KAnimationTypeScale)          : @"transform.scale",
       @(KAnimationTypeScaleX)         : @"transform.scale.x",
       @(KAnimationTypeScaleY)         : @"transform.scale.y",
       @(KAnimationTypeRotationX)      : @"transform.rotation.x",
       @(KAnimationTypeRotationY)      : @"transform.rotation.y",
       @(KAnimationTypeRotationZ)      : @"transform.rotation.z",
       @(KAnimationTypeBackgroundColor): @"backgroundColor",
       @(KAnimationTypeOpacity)        : @"opacity",
       @(KAnimationTypeCornerRadius)   : @"cornerRadius",
       @(KAnimationTypeStrokeEnd)      : @"strokeEnd",
       @(KAnimationTypeContent)        : @"contents",
       @(KAnimationTypeBorderWidth)    : @"borderWidth",
       @(KAnimationTypeShadowOffset)   : @"shadowOffset",
       @(KAnimationTypeShadowRadius)   : @"shadowRadius",
       @(KAnimationTypeShadowOpacity)  : @"shadowOpacity",
       @(KAnimationTypeShadowColor)    : @"shadowColor"
   };;
}

@end





@implementation CAKeyframeAnimation (Setup)

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                        beginTime:(CFTimeInterval)beginTime
{
    return [self animationWithType:type
                          duration:duration
                       repeatCount:1
                      autoreverses:NO
                         beginTime:beginTime
                          funcName:kCAMediaTimingFunctionLinear];
}

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                     autoreverses:(BOOL)autoreverses
                        beginTime:(CFTimeInterval)beginTime
                         funcName:(CAMediaTimingFunctionName)funcName
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:[self keyPathMap][@(type)]];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = beginTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:funcName];
    animation.autoreverses = autoreverses;
    return animation;
}



@end


@implementation CABasicAnimation (Setup)

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                        beginTime:(CFTimeInterval)beginTime
{
    return [self animationWithType:type
                          duration:duration
                       repeatCount:1
                      autoreverses:NO
                         beginTime:beginTime
                          funcName:kCAMediaTimingFunctionLinear];
}

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                     autoreverses:(BOOL)autoreverses
                        beginTime:(CFTimeInterval)beginTime
                         funcName:(CAMediaTimingFunctionName)funcName
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:[self keyPathMap][@(type)]];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = beginTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:funcName];
    animation.autoreverses = autoreverses;
    return animation;
}

@end


@implementation CASpringAnimation (Setup)

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                        beginTime:(CFTimeInterval)beginTime
{
    return [self animationWithType:type
                          duration:duration
                       repeatCount:1
                      autoreverses:NO
                         beginTime:beginTime
                          funcName:kCAMediaTimingFunctionLinear];
}

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                     autoreverses:(BOOL)autoreverses
                        beginTime:(CFTimeInterval)beginTime
                         funcName:(CAMediaTimingFunctionName)funcName
{
    CASpringAnimation * animation = [CASpringAnimation animationWithKeyPath:[self keyPathMap][@(type)]];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = beginTime;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:funcName];
    animation.autoreverses = autoreverses;
    return animation;
}

@end







@implementation CAAnimationGroup(Setup)

+ (CAAnimationGroup *)groupWithAnimations:(NSArray <CAAnimation *>*)animations
                                 duration:(NSTimeInterval)duration
                                beginTime:(CFTimeInterval)beginTime
{
    return [self groupWithAnimations:animations
                            duration:duration
                         repeatCount:1
                           beginTime:beginTime
                        autoreverses:NO
                            funcName:kCAMediaTimingFunctionLinear];
}

+ (CAAnimationGroup *)groupWithAnimations:(NSArray <CAAnimation *>*)animations
                                 duration:(NSTimeInterval)duration
                              repeatCount:(CGFloat)repeatCount
                                beginTime:(CFTimeInterval)beginTime
                             autoreverses:(BOOL)autoreverses funcName:(CAMediaTimingFunctionName)funcName
{
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.duration = duration;
    group.repeatCount = repeatCount;
    group.fillMode = kCAFillModeForwards;
    group.beginTime = beginTime;
    group.timingFunction = [CAMediaTimingFunction functionWithName:funcName];
    group.autoreverses = autoreverses;
    group.animations = animations;
    return group;
}

@end
