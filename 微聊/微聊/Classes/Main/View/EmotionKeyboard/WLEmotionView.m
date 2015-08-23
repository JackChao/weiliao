//
//  WLEmotionView.m
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionView.h"
#import "WLEmotionModel.h"
@implementation WLEmotionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHighlighted:(BOOL)highlighted {
    return;
}


- (void)setEmotion:(WLEmotionModel *)emotion {
    _emotion = emotion;
    if (emotion.isGif) {
        [self setImage:[UIImage imageNamed:emotion.image inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:emotion.image] forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

@end
