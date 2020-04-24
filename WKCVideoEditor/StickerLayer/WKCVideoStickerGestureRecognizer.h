//
//  WKCVideoStickerGestureRecognizer.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCVideoStickerGestureRecognizer : UIGestureRecognizer

/// gesture scale
@property (nonatomic, assign, readonly) CGFloat scale;

/// gesture rotation
@property (nonatomic, assign, readonly) CGFloat rotation;


/// init method
/// @param target target
/// @param action action
/// @param anchorView the achor view
- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                    anchorView:(UIView *)anchorView;

/// reset content
- (void)reset;


@end

