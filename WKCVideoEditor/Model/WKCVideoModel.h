//
//  WKCVideoMoodel.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WKCContentType) {
    WKCContentTypeImage = 0,
    WKCContentTypeVideo = 1
};

@interface WKCVideoModel : NSObject

/// image、path or AVAsset
@property (nonatomic, strong) id content;
/// type
@property (nonatomic, assign) WKCContentType type;
/// startTime
@property (nonatomic, assign) CGFloat startTime;
/// end time
@property (nonatomic, assign) CGFloat endTime;
/// duration
@property (nonatomic, assign) CGFloat duration;
/// size
@property (nonatomic, assign) CGSize size; 

@end

