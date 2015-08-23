//
//  WLEmotionPageView.h
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

/** gif 表情 最大行数*/
extern const int WLEmotionPageViewGifRowMaxCount;
/** gif 表情 最大列数*/
extern const int WLEmotionPageViewGifColMaxCount;
/** gif 表情 一页最大数量*/
extern const int WLEmotionPageViewGifPageMaxCout;

/** 普通 表情 最大行数*/
extern const int WLEmotionPageViewDefaultRowMaxCount;
/** 普通 表情 最大列数*/
extern const int WLEmotionPageViewDefaultColMaxCount;
/** 普通 表情 一页最大数量*/
extern const int WLEmotionPageViewDefaultPageMaxCount;

@interface WLEmotionPageView : UIView

@property (nonatomic, strong) NSArray *emotions;

@end
