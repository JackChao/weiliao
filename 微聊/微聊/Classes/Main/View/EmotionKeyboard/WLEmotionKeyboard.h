//
//  WLEmotionKeyboard.h
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLEmotionKeyboardNotificationConst.h"
typedef enum{
    WLEmotionKeyboardTypeDefault = 0,
    WLEmotionKeyboardTypeSimple //简单的 没有gif表情
}WLEmotionKeyboardType;

@interface WLEmotionKeyboard : UIView

@property (nonatomic, assign, readonly) WLEmotionKeyboardType keyboardType;

+ (instancetype)emotionKeyboardWithKeyboardType:(WLEmotionKeyboardType)keyboardType;
- (instancetype)initWithKeyboardType:(WLEmotionKeyboardType)keyboardType;

@end
