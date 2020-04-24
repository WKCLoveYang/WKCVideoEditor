//
//  WKCVideoPictureManager.h
//  BBCC
//
//  Created by wkcloveYang on 2020/4/22.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WKCVideoPictureManager : NSObject

+ (WKCVideoPictureManager *)shared;

- (CGAffineTransform)transformPicktureWithVideoNatureSize:(CGSize)natureSize
                                              presentSize:(CGSize)presentSize;

@end

