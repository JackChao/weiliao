//
//  WLEmotionPopView.m
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionPopView.h"
#import "WLEmotionModel.h"
#import "WLEmotionDefaultPopView.h"
#import "WLEmotionGifPopView.h"
@interface WLEmotionPopView()

@property(nonatomic, weak) WLEmotionDefaultPopView *defaultPopView;
@property(nonatomic, weak) WLEmotionGifPopView *gifPopView;
@end


@implementation WLEmotionPopView


- (void)setEmotion:(WLEmotionModel *)emotion {
    if (emotion == _emotion) {
        return;
    }
    _emotion = emotion;
    if (emotion.isGif) {
        self.gifPopView.hidden = NO;
        self.defaultPopView.hidden = YES;
        self.gifPopView.emotion = emotion;
        self.bounds = self.gifPopView.bounds;
    } else {
        self.defaultPopView.hidden = NO;
        self.gifPopView.hidden = YES;
        self.defaultPopView.emotion = emotion;
        self.bounds = self.defaultPopView.bounds;
    }
}

- (WLEmotionDefaultPopView *)defaultPopView {
    if (_defaultPopView == nil) {
        WLEmotionDefaultPopView *defaultPopView = [WLEmotionDefaultPopView emotionDefaultPopView];
        [self addSubview:defaultPopView];
        _defaultPopView = defaultPopView;
    }
    return _defaultPopView;
}

- (WLEmotionGifPopView *)gifPopView {
    if (_gifPopView == nil) {
        WLEmotionGifPopView *gifPopView = [WLEmotionGifPopView emotionGifPopView];
        [self addSubview:gifPopView];
        _gifPopView = gifPopView;
    }
    return _gifPopView;
}

/** 根据View显示 popView*/
- (void)showWithView:(UIView *)view {
    if (view == nil) {
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGRect newF = [view convertRect:view.bounds toView:window];
    CGFloat x = CGRectGetMidX(newF);
    CGFloat y = CGRectGetMidY(newF) - self.bounds.size.height * 0.5;
    self.center = CGPointMake(x, y);
    //self.frame = (CGRect){{self.frame.origin.x, y}, self.bounds.size};
    [window addSubview:self];
}
- (void)dismiss {
    [self removeFromSuperview];
    [self.gifPopView clearGifImage];
    _emotion = nil;
}
@end
