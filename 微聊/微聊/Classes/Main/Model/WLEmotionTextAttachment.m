//
//  WLEmotionTextAttachment.m
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionTextAttachment.h"
#import "WLEmotionModel.h"
@implementation WLEmotionTextAttachment

- (void)setEmotion:(WLEmotionModel *)emotion {
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.image];
}

@end
