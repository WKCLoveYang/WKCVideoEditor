//
//  CAKeyframeAnimation+Setup.h
//  ABDC
//
//  Created by wkcloveYang on 2020/3/18.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, KAnimationType) {
    KAnimationTypePosition         = 0,
    KAnimationTypePositionX        = 1,
    KAnimationTypePositionY        = 2,
    KAnimationTypeSize             = 3,
    KAnimationTypeWidth            = 4,
    KAnimationTypeHeight           = 5,
    KAnimationTypeScale            = 6,
    KAnimationTypeScaleX           = 7,
    KAnimationTypeScaleY           = 8,
    KAnimationTypeRotationX        = 9,
    KAnimationTypeRotationY        = 10,
    KAnimationTypeRotationZ        = 11,
    KAnimationTypeBackgroundColor  = 12,
    KAnimationTypeOpacity          = 13,
    KAnimationTypeCornerRadius     = 14,
    KAnimationTypeStrokeEnd        = 15,
    KAnimationTypeContent          = 16,
    KAnimationTypeBorderWidth      = 17,
    KAnimationTypeShadowOffset     = 18,
    KAnimationTypeShadowOpacity    = 19,
    KAnimationTypeShadowRadius     = 20,
    KAnimationTypeShadowColor      = 21
};

/// 注: CACurrentMediaTime()



@interface CAKeyframeAnimation (Setup)

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                        beginTime:(CFTimeInterval)beginTime;


+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                     autoreverses:(BOOL)autoreverses
                        beginTime:(CFTimeInterval)beginTime
                         funcName:(CAMediaTimingFunctionName)funcName;

@end


@interface CABasicAnimation (Setup)

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                        beginTime:(CFTimeInterval)beginTime;


+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                     autoreverses:(BOOL)autoreverses
                        beginTime:(CFTimeInterval)beginTime
                         funcName:(CAMediaTimingFunctionName)funcName;
@end


@interface CASpringAnimation (Setup)

+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                        beginTime:(CFTimeInterval)beginTime;


+ (instancetype)animationWithType:(KAnimationType)type
                         duration:(NSTimeInterval)duration
                      repeatCount:(CGFloat)repeatCount
                     autoreverses:(BOOL)autoreverses
                        beginTime:(CFTimeInterval)beginTime
                         funcName:(CAMediaTimingFunctionName)funcName;
@end







@interface CAAnimationGroup(Setup)

+ (CAAnimationGroup *)groupWithAnimations:(NSArray <CAAnimation *>*)animations
                                 duration:(NSTimeInterval)duration
                                beginTime:(CFTimeInterval)beginTime;


+ (CAAnimationGroup *)groupWithAnimations:(NSArray <CAAnimation *>*)animations
                                 duration:(NSTimeInterval)duration
                              repeatCount:(CGFloat)repeatCount
                                beginTime:(CFTimeInterval)beginTime
                             autoreverses:(BOOL)autoreverses funcName:(CAMediaTimingFunctionName)funcName;

@end
