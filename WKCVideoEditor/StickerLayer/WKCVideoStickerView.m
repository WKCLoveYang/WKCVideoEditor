//
//  WKCVideoStickerView.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoStickerView.h"
#import "WKCVideoStickerGestureRecognizer.h"
#import "CAKeyframeAnimation+Setup.h"

@interface WKCVideoStickerView()


@property (nonatomic, strong) CAShapeLayer * contentImageView;
@property (nonatomic, strong) UIImageView * topLeftView;
@property (nonatomic, strong) UIImageView * bottomLeftView;
@property (nonatomic, strong) UIImageView * topRightView;
@property (nonatomic, strong) UIImageView * gestureView;

@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong) WKCVideoStickerGestureRecognizer * stickerGesture;
@property (nonatomic, strong) UITapGestureRecognizer * topLeftGesture;
@property (nonatomic, strong) UITapGestureRecognizer * topRightGesture;
@property (nonatomic, strong) UITapGestureRecognizer * bottomLeftGesture;
@property (nonatomic, strong) UITapGestureRecognizer * contentTapGesture;

@property (nonatomic, assign) CGFloat roration;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation WKCVideoStickerView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        
        _videoRect = CGRectZero;
        _roration = 0.0;
        _scale = 1.0;
        _minScale = 0.5;
        _maxScale = 3.0;
        _onceDuration = 1.0;
        _scaleOfLimit = 0.5;
        
        _borderColor = [UIColor whiteColor];
        _borderWidth = 2;
        
        _couldDrag = YES;
        _couldRotation = YES;
        _couldScale = YES;
        
        _shouldContentHaveBorder = YES;
        _shouldContentBorderAntialias = YES;

        _itemSize = CGSizeMake(30, 30);
        
        [self addGestureRecognizer:self.contentTapGesture];
        [self addGestureRecognizer:self.panGesture];
        [self.gestureView addGestureRecognizer:self.stickerGesture];
        [self.topLeftView addGestureRecognizer:self.topLeftGesture];
        [self.topRightView addGestureRecognizer:self.topRightGesture];
        [self.bottomLeftView addGestureRecognizer:self.bottomLeftGesture];
    }
    
    return self;
}

- (void)drawShapeLayerBorder
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.contentImageView.bounds);
    [self.contentImageView setPath:path];
    CGPathRelease(path);
}

- (void)gestureActionPan:(UIPanGestureRecognizer *)sender
{
    if (!_couldDrag) {
        return;
    }
    
    CGPoint translat = [sender translationInView:self.superview];
    
    self.center = CGPointMake(self.center.x + translat.x, self.center.y + translat.y);
    
    [sender setTranslation:CGPointZero inView:[self superview]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerView:didFrameChanged:)]) {
        [self.delegate stickerView:self didFrameChanged:self.frame];
    }
}

- (void)gestureActionSticker:(WKCVideoStickerGestureRecognizer *)sender
{
    if (_couldRotation) {
        self.transform = CGAffineTransformRotate(self.transform, sender.rotation);
    }
    
    if (_couldScale) {
        self.transform = CGAffineTransformScale(self.transform, sender.scale, sender.scale);
    }
    
    if (!_couldRotation && !_couldScale) {
        return;
    }
    
    CGFloat currentScale = [[self.layer valueForKeyPath:@"transform.scale"] floatValue];
    _scale = currentScale;
    
    CGFloat currentRotation = [[self.layer valueForKeyPath:@"transform.rotation"] floatValue];
    _roration = currentRotation;
    
    [sender reset];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerView:didFrameChanged:)]) {
        [self.delegate stickerView:self didFrameChanged:self.frame];
    }
}

- (void)gestureTap:(UITapGestureRecognizer *)sender
{
    if (sender == _topLeftGesture) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerViewDidTapTopLeft:)]) {
            [self.delegate stickerViewDidTapTopLeft:self];
        }
    } else if (sender == _topRightGesture) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerViewDidTapTopRight:)]) {
            [self.delegate stickerViewDidTapTopRight:self];
        }
    } else if (sender == _bottomLeftGesture) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerViewDidTapBottomLeft:)]) {
            [self.delegate stickerViewDidTapBottomLeft:self];
        }
    } else if (sender == _contentTapGesture) {
        UIView * superView = [self superview];
        for (UIView * sub in superView.subviews) {
            if ([sub isKindOfClass:[WKCVideoStickerView class]]) {
                WKCVideoStickerView * item = (WKCVideoStickerView *)sub;
                item.shouldContentHaveBorder = NO;
            }
        }
        self.shouldContentHaveBorder = YES;
    }
}

- (void)startPlay
{
    if (!_images || _images.count == 0) {
        return;
    }
    
    if (_images.count == 1) {
        _contentImageView.contents = (id)_images.firstObject.CGImage;
        return;
    }
    
    NSMutableArray <id> * cgImages = [NSMutableArray array];
    for (UIImage * image in _images) {
        [cgImages addObject:(id)image.CGImage];
    }
    
    _isPlaying = YES;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithType:KAnimationTypeContent duration:_onceDuration beginTime:CACurrentMediaTime() + 0.0];
    animation.values = cgImages;
    animation.repeatCount = CGFLOAT_MAX;
    [_contentImageView addAnimation:animation forKey:nil];
}

- (void)stopPlay
{
    _isPlaying = NO;
    [_contentImageView removeAllAnimations];
}

#pragma mark -
- (CAShapeLayer *)contentImageView
{
    if (!_contentImageView) {
        _contentImageView = [CAShapeLayer layer];
        _contentImageView.contentsGravity = kCAGravityResizeAspectFill;
        _contentImageView.contentsScale = [[UIScreen mainScreen] scale];
        _contentImageView.masksToBounds = YES;
        _contentImageView.lineJoin = kCALineJoinBevel;
        _contentImageView.fillColor = [UIColor clearColor].CGColor;
        _contentImageView.strokeColor = _borderColor.CGColor;
        _contentImageView.lineWidth = _borderWidth;
        _contentImageView.allowsEdgeAntialiasing = YES;
        _contentImageView.lineDashPattern = @[@(5), @(3)];
        _contentImageView.needsDisplayOnBoundsChange = YES;
    }
    
    return _contentImageView;
}

- (UIImageView *)topLeftView
{
    if (!_topLeftView) {
        _topLeftView = [self createImageView];
    }
    
    return _topLeftView;
}

- (UIImageView *)bottomLeftView
{
    if (!_bottomLeftView) {
        _bottomLeftView = [self createImageView];
    }
    
    return _bottomLeftView;
}

- (UIImageView *)topRightView
{
    if (!_topRightView) {
        _topRightView = [self createImageView];
    }
    
    return _topRightView;
}

- (UIImageView *)gestureView
{
    if (!_gestureView) {
        _gestureView = [self createImageView];
    }
    
    return _gestureView;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureActionPan:)];
    }
    
    return _panGesture;
}

- (WKCVideoStickerGestureRecognizer *)stickerGesture
{
    if (!_stickerGesture) {
        _stickerGesture = [[WKCVideoStickerGestureRecognizer alloc] initWithTarget:self action:@selector(gestureActionSticker:) anchorView:self];
    }
    
    return _stickerGesture;
}

- (UITapGestureRecognizer *)topLeftGesture
{
    if (!_topLeftGesture) {
        _topLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    }
    
    return _topLeftGesture;
}

- (UITapGestureRecognizer *)topRightGesture
{
    if (!_topRightGesture) {
        _topRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    }
    
    return _topRightGesture;
}

- (UITapGestureRecognizer *)bottomLeftGesture
{
    if (!_bottomLeftGesture) {
        _bottomLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    }
    
    return _bottomLeftGesture;
}

- (UITapGestureRecognizer *)contentTapGesture
{
    if (!_contentTapGesture) {
        _contentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    }
    
    return _contentTapGesture;
}

- (UIImageView *)createImageView
{
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    return imageView;
}

#pragma mark -Setter
- (void)setVideoRect:(CGRect)videoRect
{
    _videoRect = videoRect;
    
    if (!_images || _images.count == 0) {
        NSLog(@"######## You should set the images first before set the limitRect #########");
        return;
    }
    
    CGFloat imageWidth = _images.firstObject.size.width;
    CGFloat imageHeight = _images.firstObject.size.height;
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (videoRect.size.height / videoRect.size.width > 1.0) {
        width = videoRect.size.width * _scaleOfLimit;
        height = imageHeight / imageWidth * width;
    } else {
        height = videoRect.size.height * _scaleOfLimit;
        width = imageWidth / imageHeight * height;
    }
    
    self.frame = CGRectMake(0, 0, width, height);
    self.center = CGPointMake(videoRect.origin.x + videoRect.size.width / 2.0, videoRect.origin.y + videoRect.size.height / 2.0);

    self.contentImageView.frame = self.bounds;
    [self.layer addSublayer:self.contentImageView];
    [self drawShapeLayerBorder];
    
    self.topLeftView.frame = CGRectMake(0, 0, _itemSize.width, _itemSize.height);
    self.topLeftView.center = CGPointZero;
    self.topRightView.frame = CGRectMake(0, 0, _itemSize.width, _itemSize.height);
    self.topRightView.center = CGPointMake(self.bounds.size.width, 0);
    self.bottomLeftView.frame = CGRectMake(0, height - _itemSize.height, _itemSize.width, _itemSize.height);
    self.bottomLeftView.center = CGPointMake(0, self.bounds.size.height);
    self.gestureView.frame = CGRectMake(width - _itemSize.width, height - _itemSize.height, _itemSize.width, _itemSize.height);
    self.gestureView.center = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    
    [self addSubview:self.topLeftView];
    [self addSubview:self.topRightView];
    [self addSubview:self.bottomLeftView];
    [self addSubview:self.gestureView];
}

- (void)setShouldContentHaveBorder:(BOOL)shouldContentHaveBorder
{
    _shouldContentHaveBorder = shouldContentHaveBorder;
    
    if (shouldContentHaveBorder) {
        self.contentImageView.strokeColor = _borderColor.CGColor;
        self.contentImageView.lineWidth = _borderWidth;
    } else {
        self.contentImageView.strokeColor = nil;
        self.contentImageView.lineWidth = 0;
    }
    
    [self drawShapeLayerBorder];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (!_shouldContentHaveBorder) {
        return;
    }
    
    _borderColor = borderColor;
    
    self.contentImageView.strokeColor = borderColor.CGColor;
}

 -(void)setBorderWidth:(CGFloat)borderWidth
{
    if (!_shouldContentHaveBorder) {
        return;
    }
    
    _borderWidth = borderWidth;
    self.contentImageView.lineWidth = borderWidth;
}

- (void)setShouldContentBorderAntialias:(BOOL)shouldContentBorderAntialias
{
    _shouldContentBorderAntialias = shouldContentBorderAntialias;
    
    if (shouldContentBorderAntialias) {
        self.contentImageView.allowsEdgeAntialiasing = YES;
        self.contentImageView.lineDashPattern = @[@(5), @(3)];
    } else {
        self.contentImageView.allowsEdgeAntialiasing = NO;
        self.contentImageView.lineDashPattern = nil;
    }
}

#pragma mark -hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil) {
        
        CGPoint gesturePoint = [self.gestureView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.gestureView.bounds, gesturePoint)) {
            view = self.gestureView;
        }
        
        CGPoint topLeftPoint = [self.topLeftView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.topLeftView.bounds, topLeftPoint)) {
            view = self.topLeftView;
        }
        
        CGPoint topRightPoint = [self.topRightView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.topRightView.bounds, topRightPoint)) {
            view = self.topRightView;
        }
        
        CGPoint bottomLeftPoint = [self.bottomLeftView convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.bottomLeftView.bounds, bottomLeftPoint)) {
            view = self.bottomLeftView;
        }
        
    }
    
    return view;
}

@end
