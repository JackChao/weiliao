//
//  WLEmotionDefaultPopView.m
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionDefaultPopView.h"
#import "WLEmotionModel.h"
@interface WLEmotionDefaultPopView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation WLEmotionDefaultPopView

- (void)setEmotion:(WLEmotionModel *)emotion {
    _emotion = emotion;
    self.imageView.image = [UIImage imageNamed:emotion.image];
    self.textLabel.text = [emotion.zh_Hans substringWithRange:NSMakeRange(1, emotion.zh_Hans.length - 2)];
}

+ (instancetype)emotionDefaultPopView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WLEmotionDefaultPopView" owner:nil options:nil] lastObject];
}

@end
