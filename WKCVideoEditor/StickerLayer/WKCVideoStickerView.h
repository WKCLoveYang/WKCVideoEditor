//
//  WKCVideoStickerView.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKCVideoStickerView;

@protocol WKCVideoStickerViewDelegate <NSObject>

/// tap the top left
/// @param stickerView current instance
- (void)stickerViewDidTapTopLeft:(WKCVideoStickerView *)stickerView;

/// tap the top right
/// @param stickerView current instance
- (void)stickerViewDidTapTopRight:(WKCVideoStickerView *)stickerView;

/// tap the bottom left
/// @param stickerView current instance
- (void)stickerViewDidTapBottomLeft:(WKCVideoStickerView *)stickerView;

/// tap the sticker
/// @param stickerView current instance
- (void)stickerViewDidTapContent:(WKCVideoStickerView *)stickerView;

/// when drag the sticker, or rotation scale the sticker, frame changed
/// @param stickerView current instance
/// @param newFrame new frame
- (void)stickerView:(WKCVideoStickerView *)stickerView didFrameChanged:(CGRect)newFrame;

@end



@interface WKCVideoStickerView : UIView

/// delegate
@property (nonatomic, weak) id<WKCVideoStickerViewDelegate> delegate;

/// the min scale of sticker, default is 0.5
@property (nonatomic, assign) CGFloat minScale;

/// the max scale of sticker, deault is 3.0
@property (nonatomic, assign) CGFloat maxScale;

/// if sticker contents are image frame animation, set once duration of it.
@property (nonatomic, assign) NSTimeInterval onceDuration;

/// contents, if single, will be satic, no animation.
@property (nonatomic, strong) NSArray <UIImage *> * images;

/// get the min item of sticker's width and height, then sticker's width or height will be scale of limit. Default is 0.5.
@property (nonatomic, assign) CGFloat scaleOfLimit;

/// the video frame. It must be setted, then stciker's frame was be setted.
@property (nonatomic, assign) CGRect videoRect;



/// content should  have border, default is YES.
@property (nonatomic, assign) BOOL shouldContentHaveBorder;

/// content border width, if shouldContentHaveBorder is YES.
@property (nonatomic, assign) CGFloat borderWidth;

/// content border color, if shouldContentHaveBorder is YES.
@property (nonatomic, strong) UIColor * borderColor;

/// content border should have antialias, if shouldContentHaveBorder is YES.
@property (nonatomic, assign) BOOL shouldContentBorderAntialias;



/// if the sticker can be dragged, default is YES.
@property (nonatomic, assign) BOOL couldDrag;

/// if the sticker can be rotated, default is YES.
@property (nonatomic, assign) BOOL couldRotation;

/// if the sticker can be scaled, default is YES.
@property (nonatomic, assign) BOOL couldScale;


/// current rotation of sticker
@property (nonatomic, assign, readonly) CGFloat roration;

/// current scale of sticker
@property (nonatomic, assign, readonly) CGFloat scale;

/// is animation playing
@property (nonatomic, assign, readonly) BOOL isPlaying;

/// top left imageView
@property (nonatomic, strong, readonly) UIImageView * topLeftView;

/// bottom left imageView
@property (nonatomic, strong, readonly) UIImageView * bottomLeftView;

/// top right imageView
@property (nonatomic, strong, readonly) UIImageView * topRightView;

/// gesture imageView
@property (nonatomic, strong, readonly) UIImageView * gestureView;

/// the item's size
@property (nonatomic, assign ,readonly) CGSize itemSize;



/// play animation
- (void)startPlay;

/// stop animation
- (void)stopPlay;


@end

