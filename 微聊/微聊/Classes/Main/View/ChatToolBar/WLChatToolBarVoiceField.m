//
//  WLChatToolBarVoiceView.m
//  微聊
//
//  Created by weimi on 15/8/1.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatToolBarVoiceField.h"
#import "WLChatToolBarVoiceFieldSpeakView.h"
#import "MBProgressHUD+MJ.h"

@interface WLChatToolBarVoiceField()

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) WLChatToolBarVoiceFieldSpeakView *speakView;
@property (nonatomic, strong) UIView *deleteView;

@end


@implementation WLChatToolBarVoiceField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)speakView {
    if (_speakView == nil) {
        _speakView = [[WLChatToolBarVoiceFieldSpeakView alloc] init];
    }
    return _speakView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"chat_input_button_voice_bg"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"chat_input_button_voice_bg_pressed"] forState:UIControlStateHighlighted];
        [self setTitle:@"按住说话" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.001;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    
    CGPoint point = [longPress locationInView:self];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{//开始语音输入
            self.highlighted = YES;
            self.startTime = [[NSDate date] timeIntervalSince1970];
            self.speakView.type = WLChatToolBarVoiceFieldSpeakViewTypeNormal;
            [self.speakView show];
            break;
        }
        case UIGestureRecognizerStateChanged: {//触摸位置发生改变
            if ([self pointInView:point]) {
                self.speakView.type = WLChatToolBarVoiceFieldSpeakViewTypeNormal;
            }
            else self.speakView.type = WLChatToolBarVoiceFieldSpeakViewTypeDelete;
            break;
        }
        case UIGestureRecognizerStateEnded: {//结束语音输入 判断  触摸是否在 self 上 是则发送语音
            [self.speakView remove];
            self.highlighted = NO;
            if ([self pointInView:point]) {
                NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
                if (endTime - self.startTime < 1.0) {
                    [MBProgressHUD showError:@"录制时间太短"];
                }
            }
            break;
        }
        default:{//其他状况  结束语音
            [self.speakView remove];
            self.highlighted = NO;
            break;
        }
    }
}


- (BOOL)pointInView:(CGPoint) point{
    CGRect rect = CGRectMake(-60, -30, self.bounds.size.width + 120, self.bounds.size.height + 60);
    return CGRectContainsPoint(rect, point);
}
@end
