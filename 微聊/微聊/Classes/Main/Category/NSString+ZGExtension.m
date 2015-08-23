//
//  NSString+Extension.m
//  微聊
//
//  Created by weimi on 15/7/16.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "NSString+ZGExtension.h"
#import "WLEmotionTool.h"
#import "WLHighlightText.h"
#import "UIColor+ZGExtension.h"
#import "WLEmotionTextAttachment.h"

@implementation NSString (ZGExtension)

- (NSString *)timeStringWithcurrentTime {
    if ([self isEqualToString:@"刚刚"]) {
        return @"刚刚";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [dateFormatter dateFromString:self];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = dateFormatter.locale;
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comSub = [calendar components:unit fromDate:date toDate:now options:0];
    NSDateComponents *comPre = [calendar components:unit fromDate:date];
    NSDateComponents *comNow = [calendar components:unit fromDate:now];
    if (comPre.year != comNow.year) {//不是同一年
        //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [dateFormatter stringFromDate:date];
    } else if(comPre.month == comNow.month) {//同一月
        if (comPre.day == comNow.day) {//同一天
            if (comSub.hour == 0) {//相差不足一小时
                if (comSub.minute <= 1) {
                    return [NSString stringWithFormat:@"刚刚"];
                }
                return [NSString stringWithFormat:@"%ld分钟前",(long)comSub.minute];
            } else if(comSub.hour <= 5) {//相差不足5小时
                return [NSString stringWithFormat:@"%ld小时前",(long)comSub.hour];
            } else {
                dateFormatter.dateFormat = @"HH:mm:ss";
                return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
            }
        } else if(comSub.day <= 1){//昨天
            dateFormatter.dateFormat = dateFormatter.dateFormat = @"HH:mm:ss";
            return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:date]];
        } else {//本月
            dateFormatter.dateFormat = @"dd日 HH:mm:ss";
            return [dateFormatter stringFromDate:date];
        }
    } else {//本年
        dateFormatter.dateFormat = @"MM-dd HH:mm:ss";
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)stringToPinYin {
    NSMutableString *str = [NSMutableString stringWithString:self];
    NSMutableString *pinYin = [NSMutableString string];
    //将字符串转为拼音
    if (CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformMandarinLatin, NO)) {
        if (CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformStripDiacritics, NO)) {
            NSUInteger len = str.length;
            //提取首字母
            BOOL flag = YES;
            for (NSUInteger i = 0; i < len; i++) {
                char c = [str characterAtIndex:i];
                if (c == ' ') {
                    flag = YES;
                } else if(flag || c < 'a' || c > 'z') {
                    flag = NO;
                    [pinYin appendFormat:@"%c", c];
                }
            }
        }
        
    }
    return pinYin;
}

- (NSAttributedString *)attributedStringWithFont:(UIFont *)font {
    return [self attributedStringWithFont:font highlights:nil];
}

- (NSAttributedString *)attributedStringWithFont:(UIFont *)font highlights:(void (^)(NSArray *))highlights {
    NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4E00-\\u9FA5]+\\]";
    NSString *urlPattern = @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:[NSString stringWithFormat:@"%@|%@", emotionPattern, urlPattern] options:0 error:nil];
    NSArray *results = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray *attributedTexts = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        WLHighlightText *attributedText = [[WLHighlightText alloc] init];
        attributedText.range = result.range;
        attributedText.text = [self substringWithRange:result.range];
        [attributedTexts addObject:attributedText];
    }
    int count = (int)attributedTexts.count;
    for (int i = count - 1; i >= 0; i--) {//从后往前遍历  替换需要  处理的 字符串
        WLHighlightText *attributedText = attributedTexts[i];
        if (attributedText.isEmotion) {
            WLEmotionModel *emotion = [WLEmotionTool emotionWithZh_Hans:attributedText.text];
            if (emotion) {
                WLEmotionTextAttachment *emotionTextAttachment = [[WLEmotionTextAttachment alloc] init];
                emotionTextAttachment.emotion = emotion;
                emotionTextAttachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
                NSAttributedString *emotionAttributedText = [NSAttributedString attributedStringWithAttachment:emotionTextAttachment];
                [attributedResult replaceCharactersInRange:attributedText.range withAttributedString:emotionAttributedText];
            }
        } else {
            [attributedResult addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithR:49 g:107 b:223 alpha:0.9] range:attributedText.range];
        }
        
    }
    //给block 传入 hilightTexts  点击需要高亮的内容  如 链接
    if (highlights) {
        NSMutableArray *highlightTexts = [NSMutableArray array];
        int offset = 0;
        for (WLHighlightText *attr in attributedTexts) {
            if (attr.isEmotion) {
                WLEmotionModel *emotion = [WLEmotionTool emotionWithZh_Hans:attr.text];
                if (emotion) {
                    offset += attr.range.length - 1;
                }
            } else {
                attr.range = NSMakeRange(attr.range.location - offset, attr.range.length);
                [highlightTexts addObject:attr];
            }
        }
        highlights(highlightTexts);
        
    }
    
    [attributedResult addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedResult.length)];
    
    return attributedResult;
}

@end
