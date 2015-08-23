//
//  WLEmotionGifPopView.m
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionGifPopView.h"
#import "WLEmotionModel.h"
#import "WLEmotionTool.h"
@interface WLEmotionGifPopView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation WLEmotionGifPopView

- (void)setEmotion:(WLEmotionModel *)emotion {
    _emotion = emotion;
    //[UIImage imageNamed:emotion.image inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
    
    self.imageView.image = [WLEmotionTool gifImageWithEmotion:emotion];
}

+ (instancetype)emotionGifPopView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WLEmotionGifPopView" owner:nil options:nil] lastObject];
}

- (void)clearGifImage {
    self.imageView.image = nil;
}

@end
