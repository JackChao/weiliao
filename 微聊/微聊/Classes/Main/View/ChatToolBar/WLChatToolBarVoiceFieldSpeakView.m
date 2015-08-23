//
//  WLChatToolBarVoiceFieldSpeakView.m
//  微聊
//
//  Created by weimi on 15/8/1.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatToolBarVoiceFieldSpeakView.h"
#import "UIColor+ZGExtension.h"
#import "WLAVTool.h"
const double kViewW = 150.0;
const double kViewH = 150.0;
const double kTextLabelW = kViewW;
const double kTextLabelH = 10.0;
const double kImageViewW = 80.0;
const double kImageViewH = kImageViewW;
const double kImageViewX = (kViewW - kImageViewW) * 0.5;
const double kImageViewY = 20.0;
const double kTextLabelY = kImageViewY + kImageViewH + 10;
const double kTextLabelX = 0;

const double kMaskViewW = 30.0;
const double kMaskViewH = 16.0;
const double kMaskViewX = (kImageViewW  - kMaskViewW) * 0.5;
const double kMaskViewY = 40.0;
const double kMaskViewMaxY = kMaskViewH + kMaskViewY;

#define normalImage @"chat_hold_to_speak_icon"
#define deleteImage  @"chat_hold_to_speak_icon_delete"
#define maskImage @"chat_hold_to_speak_icon_delete_mask"
#define normalText @"手指上滑, 取消发送"
#define deleteText @"松开手指, 取消发送"
#define normalColor [UIColor colorWithR:47.0 g:47.0 b:47.0 alpha:0.9]
#define deleteColor [UIColor colorWithR:225.0 g:74.0 b:80.0 alpha:0.9]
@interface WLChatToolBarVoiceFieldSpeakView()

@property (nonatomic, weak) UILabel *textLabel;
@property (nonatomic, weak) UIImageView *imageView;
/** 用于 语音输入时动画*/
@property (nonatomic, weak) UIImageView *maskView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *voiceName;

@end

@implementation WLChatToolBarVoiceFieldSpeakView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, kViewW, kViewH);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        //图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(kImageViewX, kImageViewY, kImageViewW, kImageViewH);
        self.imageView = imageView;
        [self addSubview:imageView];
        //标签
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(kTextLabelX, kTextLabelY, kTextLabelW, kTextLabelH);
        self.textLabel = textLabel;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:textLabel];
        self.type = WLChatToolBarVoiceFieldSpeakViewTypeNormal;
        
        //maskView
        UIImageView *maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_hold_to_speak_icon_delete_mask"]];
        self.maskView = maskView;
        self.maskView.frame = CGRectMake(kMaskViewX, kMaskViewY, kMaskViewW, kMaskViewH);
        [self.imageView addSubview:maskView];
        
    }
    return self;
}

- (void)setType:(WLChatToolBarVoiceFieldSpeakViewType)type {
    if (_type == type) {
        return;
    }
    _type = type;
    if (type == WLChatToolBarVoiceFieldSpeakViewTypeDelete) {
        self.maskView.hidden = YES;
        self.imageView.image = [UIImage imageNamed:deleteImage];
        self.textLabel.text = deleteText;
        self.backgroundColor = deleteColor;
    } else {
        self.maskView.hidden = NO;
        self.imageView.image = [UIImage imageNamed:normalImage];
        self.textLabel.text = normalText;
        self.backgroundColor = normalColor;
    }
}

- (void)maskViewAnimation {
    CGFloat H = kMaskViewH + [WLAVTool getCurrentMicDB] * 25;
    self.maskView.frame = CGRectMake(kMaskViewX, kMaskViewMaxY - H, kMaskViewW, H);
}

-(void)show {
    [self removeFromSuperview];
    if (self.type == WLChatToolBarVoiceFieldSpeakViewTypeNormal) {
        //开始录音
        self.voiceName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [WLAVTool startRecorder:self.voiceName];
        //设置定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(maskViewAnimation) userInfo:nil repeats:YES];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)remove {
    //停止录音
    [WLAVTool stopRecorder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WLAVTool playVoice:self.voiceName];
    });
    
    [self removeFromSuperview];
    //停止计时器
    [self.timer invalidate];
}
@end
