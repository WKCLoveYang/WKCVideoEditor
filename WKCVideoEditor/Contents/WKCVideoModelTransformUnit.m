//
//  WKCVideoModelTransformUnit.m
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import "WKCVideoModelTransformUnit.h"
#import "NSString+AssetInfo.h"

#define WKC_Video_Quality_Low CGSizeMake(340, 480)
#define WKC_Video_Quality_Medium CGSizeMake(480, 640)
#define WKC_Video_Quality_High CGSizeMake(540, 960)
#define WKC_Video_Quality_SuperHigh CGSizeMake(720, 1280)

@interface WKCVideoModelTransformUnit()

@property (nonatomic, strong) NSArray <WKCVideoModel *> * models;

@property (nonatomic, strong) NSArray <id> * contents;
@property (nonatomic, assign) CGFloat imageDuration;
@property (nonatomic, assign) CGSize videoSize;


@end

@implementation WKCVideoModelTransformUnit

+ (CGSize)sizeWithQuality:(WKCVideoQuality)quality
{
    if (quality == WKCVideoQualityLow) {
        return WKC_Video_Quality_Low;
    } else if (quality == WKCVideoQualityMedium) {
        return WKC_Video_Quality_Medium;
    } else if (quality == WKCVideoQualityHigh) {
        return WKC_Video_Quality_High;
    } else if (quality == WKCVideoQualitySuperHigh) {
        return WKC_Video_Quality_SuperHigh;
    } else {
        return CGSizeZero;
    }
}

- (instancetype)initWithContents:(NSArray <id>*)contents
                   imageDuration:(CGFloat)imageDuration
                         quality:(WKCVideoQuality)quality
                      customSize:(CGSize)customSize
{
    if (self = [super init]) {
        _contents = contents;
        _imageDuration = imageDuration;
        
        if (quality == WKCVideoQualityLow) {
            _videoSize = WKC_Video_Quality_Low;
        } else if (quality == WKCVideoQualityMedium) {
            _videoSize = WKC_Video_Quality_Medium;
        } else if (quality == WKCVideoQualityHigh) {
            _videoSize = WKC_Video_Quality_High;
        } else if (quality == WKCVideoQualitySuperHigh) {
            _videoSize = WKC_Video_Quality_SuperHigh;
        } else if (quality == WKCVideoQualityCustom) {
            _videoSize = customSize;
        }
    }
    
    return self;
}

- (NSArray<WKCVideoModel *> *)models
{
    if (!_models) {
        
        NSMutableArray * array = [NSMutableArray array];
        CGFloat time = 0;
        
        for (int i = 0; i < _contents.count; i ++) {
            id item = _contents[i];
            WKCVideoModel * model = [[WKCVideoModel alloc] init];
            model.startTime = time;
            if ([item isKindOfClass:[UIImage class]]) {
                UIImage * image = item;
                model.duration = _imageDuration;
                model.size = image.size;
                model.type = WKCContentTypeImage;
                model.content = [image sizeToFit:_videoSize type:_imageResizeType shoudBgEffect:_shouldImageBgEffect];
            } else if ([item isKindOfClass:[NSString class]]) {
                NSString * path = item;
                model.duration = [path videoDuration];
                model.size = [path videoSize];
                model.type = WKCContentTypeVideo;
                model.content = path;
            } else if ([item isKindOfClass:[AVAsset class]]) {
                AVAsset * asset = item;
                model.content = item;
                model.duration = [asset videoDuration];
                model.size = [asset videoSize];
                model.type = WKCContentTypeVideo;
            } else {
                continue;
            }
            
            time += model.duration;
            
            model.endTime = time;

            [array addObject:model];
        }
        
        _models = array;
    }
    
    return _models;

}

- (NSTimeInterval)totalDuration
{
    int duration = 0;
    for (int i = 0; i < self.models.count; i ++) {
        duration += self.models[i].duration;
    }
    return duration;
}

- (BOOL)hasVideo
{
    BOOL hasVideo = NO;
    for (WKCVideoModel * item in self.models) {
        if (item.type == WKCContentTypeVideo) {
            hasVideo = YES;
            break;
        }
    }
    
    return hasVideo;
}

- (BOOL)hasImage
{
    BOOL hasImage = NO;
    for (WKCVideoModel * item in self.models) {
        if (item.type == WKCContentTypeImage) {
            hasImage = YES;
            break;
        }
    }
    
    return hasImage;
}


#pragma mark -Setter
- (void)setQuality:(WKCVideoQuality)quality
{
    _quality = quality;
    
    if (quality == WKCVideoQualityLow) {
        _videoSize = WKC_Video_Quality_Low;
    } else if (quality == WKCVideoQualityMedium) {
        _videoSize = WKC_Video_Quality_Medium;
    } else if (quality == WKCVideoQualityHigh) {
        _videoSize = WKC_Video_Quality_High;
    } else if (quality == WKCVideoQualitySuperHigh) {
        _videoSize = WKC_Video_Quality_SuperHigh;
    } else if (quality == WKCVideoQualityCustom) {
        _videoSize = _customSize;
    }
}

- (void)setCustomSize:(CGSize)customSize
{
    if (_quality != WKCVideoQualityCustom) {
        return;
    }
    
    _customSize = customSize;
    _videoSize = customSize;
}

@end
