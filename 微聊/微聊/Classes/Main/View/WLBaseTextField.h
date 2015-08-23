//
//  WLBaseTextField.h
//  微聊
//
//  Created by weimi on 15/7/31.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WLBaseTextFieldFrameDidChangeNotification @"WLBaseTextFieldFrameDidChangeNotification"
#define WLBaseTextFieldFrameDidChangeNotificationKey  @"WLBaseTextFieldFrameDidChangeNotificationKey"

#define WLBaseTextFieldTextDidChangeNotification @"WLBaseTextFieldTextDidChangeNotification"
#define WLBaseTextFieldTextDidChangeNotificationKey  @"WLBaseTextFieldTextDidChangeNotificationKey"

@class WLEmotionModel;

@interface WLBaseTextField : UITextView

/** 占位文字*/
@property (nonatomic, strong) NSString *placeholder;
/** 占位文字颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;
/** 背景图片*/
@property (nonatomic, strong) UIImage *background;
/** 最小高度 默认的等于初始frame的高度*/
@property (nonatomic, assign) CGFloat minHeight;
/** 最大高度 默认的等于85*/
@property (nonatomic, assign) CGFloat maxHeight;
/** 发送 text 改变通知*/
- (void)postTextDidChangeNotification;
/** 插入一个表情*/
- (void)insertEmotion:(WLEmotionModel *)emotion;
/** 返回全部文本*/
- (NSString *)fullText;
@end
