//
//  WLEmotionTool.m
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionTool.h"
#import "MJExtension.h"
#import "WLEmotionModel.h"
#include "UIImage+GIF.h"
#include "ZGVL.h"
static NSArray *_emotionDefaults = nil;
static NSArray *_emotionMitus = nil;
static NSArray *_emotionOctopuses = nil;

@implementation WLEmotionTool

+ (NSArray *)emotionDefaults {
    if (_emotionDefaults == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"plist"];
        _emotionDefaults = [WLEmotionModel objectArrayWithFile:path];
    }
    return _emotionDefaults;
}

+ (NSArray *)emotionMitus {
    if (_emotionMitus == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mitu" ofType:@"plist"];
        _emotionMitus = [WLEmotionModel objectArrayWithFile:path];
    }
    return _emotionMitus;
}

+ (NSArray *)emotionOctopuses {
    if (_emotionOctopuses == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"octopus" ofType:@"plist"];
        _emotionOctopuses = [WLEmotionModel objectArrayWithFile:path];
    }
    return _emotionOctopuses;
}

/** 返回默认表情模型数据*/
+ (NSArray *)defaultEmotions {
    return [self emotionDefaults];
}
/** 返回米兔表情模型数据*/
+ (NSArray *)mituEmotions {
    return [self emotionMitus];
}
/** 返回章鱼表情模型数据*/
+ (NSArray *)octopusEmotions {
    return [self emotionOctopuses];
}

+ (WLEmotionModel *)emotionWithZh_Hans:(NSString *)key {
    for (WLEmotionModel *emotion in [self emotionDefaults]) {
        if ([emotion.zh_Hans isEqualToString:key]) {
            return emotion;
        }
    }
    for (WLEmotionModel *emotion in [self emotionMitus]) {
        if ([emotion.zh_Hans isEqualToString:key]) {
            return emotion;
        }
    }
    for (WLEmotionModel *emotion in [self emotionOctopuses]) {
        if ([emotion.zh_Hans isEqualToString:key]) {
            return emotion;
        }
    }
    return nil;
}

+ (UIImage *)gifImageWithEmotion:(WLEmotionModel *)emotion {
    NSString *path = [[NSBundle mainBundle] pathForResource:emotion.image ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage sd_animatedGIFWithData:data];
}

@end
