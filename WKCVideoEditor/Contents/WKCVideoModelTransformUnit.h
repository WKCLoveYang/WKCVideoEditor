//
//  WKCVideoModelTransformUnit.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCVideoModel.h"
#import "UIImage+category.h"

typedef NS_ENUM(NSInteger, WKCVideoQuality) {
    WKCVideoQualityLow        = 0, // 480 * 340
    WKCVideoQualityMedium     = 1, // 640 * 480
    WKCVideoQualityHigh       = 2, // 960 * 540
    WKCVideoQualitySuperHigh  = 3, // 1280 * 720
    WKCVideoQualityCustom     = 4  // custom
};

@interface WKCVideoModelTransformUnit : NSObject

@property (nonatomic, strong, readonly) NSArray <WKCVideoModel *> * models;
/// the create video size
@property (nonatomic, assign, readonly) CGSize videoSize;
/// all contents total duration
@property (nonatomic, assign, readonly) NSTimeInterval totalDuration;
/// did contents has video
@property (nonatomic, assign, readonly) BOOL hasVideo;
/// did contents has image
@property (nonatomic, assign, readonly) BOOL hasImage;

/// set the quality
@property (nonatomic, assign) WKCVideoQuality quality;
/// set customSize
@property (nonatomic, assign) CGSize customSize;
/// if image bg set light effect, default is no
@property (nonatomic, assign) BOOL shouldImageBgEffect;
/// if image, set the resize type, default is scale
@property (nonatomic, assign) WKCVideoResizeType imageResizeType;



/// init method
/// @param contents UIImage、videoPath or AVAsset
/// @param imageDuration UIImage per duration
/// @param quality for video size
/// @param customSize when WKCVideoQuality == WKCVideoQualityCustom, use customSize
- (instancetype)initWithContents:(NSArray <id>*)contents
                   imageDuration:(CGFloat)imageDuration
                         quality:(WKCVideoQuality)quality
                      customSize:(CGSize)customSize;

/// transform quality to video size, when custom size, return CGSizeZero
+ (CGSize)sizeWithQuality:(WKCVideoQuality)quality;

@end

