//
//  WLEmotionTool.h
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class WLEmotionModel;

@interface WLEmotionTool : NSObject

/** 返回默认表情模型数据*/
+ (NSArray *)defaultEmotions;
/** 返回米兔表情模型数据*/
+ (NSArray *)mituEmotions;
/** 返回章鱼表情模型数据*/
+ (NSArray *)octopusEmotions;

/** 根据  表情对应的文字  返回一个表情模型*/
+ (WLEmotionModel *)emotionWithZh_Hans:(NSString *)key;

/** 返回一张 gif 表情图片 其会自动更新  产生动态效果*/
+ (UIImage *) gifImageWithEmotion:(WLEmotionModel *) emotion;
@end
