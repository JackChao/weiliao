//
//  WLPostStatusToolBar.m
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLPostStatusToolBar.h"

@interface WLPostStatusToolBar()

@property (nonatomic, weak) UIButton *emotionBtn;

@end

@implementation WLPostStatusToolBar

- (UIButton *)emotionBtn {
    if (_emotionBtn == nil) {
        UIButton *emotionBtn = [[UIButton alloc] init];
        _emotionBtn = emotionBtn;
        [emotionBtn addTarget:self action:@selector(emotionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emotionBtn];
    }
    return _emotionBtn;
}

- (void)emotionBtnClick {
    if ([self.delegate respondsToSelector:@selector(postStatusToolBarEmotionBtnDidClick:)]) {
        [self.delegate postStatusToolBarEmotionBtnDidClick:self];
    }
}

- (void)setEmotionBtnType:(WLPostStatusToolBarEmotionBtnType)emotionBtnType {
    _emotionBtnType = emotionBtnType;
    NSString *image = nil;
    NSString *highlightedImage = nil;
    if (emotionBtnType == WLPostStatusToolBarEmotionBtnTypeFace) {//表情输入状态  需转化为非普通输入状态
        image = @"chat_bottom_icon_expression";
        highlightedImage = @"chat_bottom_icon_expression_pressed";
        
    } else {
        image = @"chat_bottom_icon_keyboard";
        highlightedImage = @"chat_bottom_icon_keyboard_pressed";
        
    }
    [self.emotionBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionBtn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.emotionBtnType = WLPostStatusToolBarEmotionBtnTypeFace;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenW = self.bounds.size.width;
    CGFloat emotionBtnH = self.bounds.size.height;
    CGFloat emotionBtnW = emotionBtnH;
    CGFloat emotionBtnX = screenW - emotionBtnW;
    CGFloat emotionBtnY = 0;
    self.emotionBtn.frame = CGRectMake(emotionBtnX, emotionBtnY, emotionBtnW, emotionBtnH);
}

@end
