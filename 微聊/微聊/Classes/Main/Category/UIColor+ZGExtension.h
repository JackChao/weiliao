//
//  UIColor+Extension.h
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZGExtension)

+ (instancetype)colorWithR:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b alpha:(CGFloat)alpha;
/** 随机色*/
+ (instancetype)randomColor;
/** 分割线颜色*/
+ (instancetype)divideColor;
/**
 *  detail 灰色
 */
+ (instancetype)detailColor;
@end
