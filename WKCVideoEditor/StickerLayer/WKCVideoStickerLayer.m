//
//  WKCVideoStickerLayer.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoStickerLayer.h"
#import "CAKeyframeAnimation+Setup.h"
#import <AVFoundation/AVFoundation.h>

@interface WKCVideoStickerLayer()<CAAnimationDelegate>
{
    NSTimeInterval _innerBeginTime;
    NSTimeInterval _innerDuration;
}

@property (nonatomic, strong) WKCVideoStickerView * stickerView;
@property (nonatomic, assign) CGSize videoNaturalSize;

@end

@implementation WKCVideoStickerLayer

- (instancetype)initWithStickerView:(WKCVideoStickerView *)stickerView
                    videoNatureSize:(CGSize)videoNatureSize
                          beginTime:(NSTimeInterval)beginTime
                           duration:(NSTimeInterval)duration
{
    if (self = [super init]) {
        _stickerView = stickerView;
        _videoNaturalSize = videoNatureSize;
        _innerBeginTime = beginTime;
        _innerDuration = duration;
        
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    self.contentsGravity = kCAGravityResizeAspectFill;
    self.masksToBounds = YES;
    self.anchorPointZ = 0;
    self.anchorPoint = CGPointZero;
    
    self.frame = [self getTheLayerFrame];
    self.transform = CATransform3DMakeRotation(-_stickerView.roration, 0, 0, 1);
    
    CAKeyframeAnimation * imagesAnimation = [CAKeyframeAnimation animationWithType:KAnimationTypeContent duration:_stickerView.onceDuration beginTime:AVCoreAnimationBeginTimeAtZero + _innerBeginTime];
    imagesAnimation.repeatCount = _innerDuration / _stickerView.onceDuration;
    NSMutableArray <id>* contents = [NSMutableArray array];
    for (UIImage * image in _stickerView.images) {
        [contents addObject:(id)image.CGImage];
    }
    imagesAnimation.values = contents;
    imagesAnimation.delegate = self;
    [self addAnimation:imagesAnimation forKey:nil];
}


- (CGRect)getLayerFrame
{
    CGFloat scale = _videoNaturalSize.height / _stickerView.videoRect.size.height;
    
    CGFloat x = (CGRectGetMinX(_stickerView.frame) - _stickerView.videoRect.origin.x) * scale;
    CGFloat y = (CGRectGetMinY(_stickerView.frame) - _stickerView.videoRect.origin.y) * scale;
    
    CGFloat borderWidth = _stickerView.frame.size.width;
    CGFloat borderHeight = _stickerView.frame.size.height;
    
    CGFloat realHeight = 0;
    CGFloat realWidth = 0;
    
    if (_stickerView.roration == 0) {
        realHeight = borderHeight;
        realWidth = borderWidth;
    } else {
        realHeight = (borderHeight * cos(fabs(_stickerView.roration)) - borderWidth * sin(fabs(_stickerView.roration))) / (cos(fabs(_stickerView.roration)) * cos(fabs(_stickerView.roration)) - sin(fabs(_stickerView.roration)) * sin(fabs(_stickerView.roration)));
        realWidth = (borderHeight - realHeight * cos(fabs(_stickerView.roration))) / sin(fabs(_stickerView.roration));
    }

    CGFloat width = realWidth * scale;
    CGFloat height = realHeight * scale;
    
    return CGRectMake(x, _videoNaturalSize.height - y - height, width, height);
}

- (CGRect)getTheLayerFrame
{
    CGFloat scale = _videoNaturalSize.height / _stickerView.videoRect.size.height;
    
    CGFloat stickerRectX = (CGRectGetMinX(_stickerView.frame) - _stickerView.videoRect.origin.x) * scale;
    CGFloat stickerRectY = (CGRectGetMinY(_stickerView.frame) - _stickerView.videoRect.origin.y) * scale;
    CGFloat stickerRectWidth = _stickerView.frame.size.width * scale;
    CGFloat stickerRectHeight = _stickerView.frame.size.height * scale;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (_stickerView.roration == 0) {
        x = stickerRectX;
        y = stickerRectY;
        width = stickerRectWidth;
        height = stickerRectHeight;
    } else {
        height = (stickerRectHeight * cos(fabs(_stickerView.roration)) - stickerRectWidth * sin(fabs(_stickerView.roration))) / (cos(fabs(_stickerView.roration)) * cos(fabs(_stickerView.roration)) - sin(fabs(_stickerView.roration)) * sin(fabs(_stickerView.roration)));
        width = (stickerRectHeight - height * cos(fabs(_stickerView.roration))) / sin(fabs(_stickerView.roration));
        if (_stickerView.roration > 0) {
            x = stickerRectX;
            y = stickerRectY;
        } else {
            x = stickerRectX + (stickerRectWidth - width) * 3.0 / 2.0;
            y = stickerRectY + stickerRectHeight - height;
        }
    }
     
    return CGRectMake(x, _videoNaturalSize.height - y - height, width, height);
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_innerDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllAnimations];
    });
}

@end
