//
//  NSString+Extension.h
//  微聊
//
//  Created by weimi on 15/7/16.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIFont;
@interface NSString (ZGExtension)

/** 根据当前时间算出时间的显示(刚刚, 今天XX:XX, 昨天XX:XX, X月X日, X年X月X日)*/
- (NSString *)timeStringWithcurrentTime;

/** 得到字符串的各个字符的拼音首字母,忽略空格*/
- (NSString *)stringToPinYin;

/** 返回带有格式的 字符串  替换表情, 链接等*/
- (NSAttributedString *) attributedStringWithFont:(UIFont *)font;

/** 返回带有格式的 字符串  替换表情, 链接等 block 用于接收 点击需要高亮的字符串模型数组(WLHighlightText)*/
- (NSAttributedString *) attributedStringWithFont:(UIFont *)font highlights:(void (^)(NSArray *hilightTexts)) highlights;

@end
