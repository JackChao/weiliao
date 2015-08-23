//
//  WLAttributedString.m
//  微聊
//
//  Created by weimi on 15/8/4.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLHighlightText.h"

@implementation WLHighlightText

- (void)setText:(NSString *)text {
    _text = [text copy];
    if ([text hasPrefix:@"["] && [text hasSuffix:@"]"]) {
        self.isEmotion = YES;
    } else {
        self.isEmotion = NO;
    }
}

@end
