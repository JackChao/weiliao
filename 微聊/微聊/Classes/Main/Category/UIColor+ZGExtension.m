//
//  UIColor+Extension.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "UIColor+ZGExtension.h"

@implementation UIColor (ZGExtension)

+ (instancetype)colorWithR:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b alpha:(CGFloat)alpha {
    return [self colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}
+ (instancetype)randomColor {
    return [self colorWithR:rand() % 256 g:rand() % 256 b:rand() % 256 alpha:1.0];
}
+ (instancetype)divideColor {
    return [self colorWithR:214.0 g:214.0 b:214.0 alpha:0.8];
}
+ (instancetype)detailColor {
    return [self colorWithR:110 g:110 b:110 alpha:1.0];
}
@end
