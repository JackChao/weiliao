//
//  WLChatToolBar.m
//  微聊
//
//  Created by weimi on 15/7/30.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatToolBar.h"
#import "UIColor+ZGExtension.h"
#import "WLBaseTextField.h"
#import "WLChatToolBarVoiceField.h"
#import "WLEmotionKeyboard.h"
#import "WLEmotionModel.h"
#define WLChatToolBarScreenSize [UIScreen mainScreen].bounds.size
const double kToolBarH = 50.0;
const double kBtnH = 50.0;
const double kBtnW = 45.0;
const double kTextFieldPadding = 7.0;

@interface WLChatToolBar()<UITextViewDelegate>
/** 语音按钮*/
@property (nonatomic, weak) UIButton *voiceBtn;
/** 表情按钮*/
@property (nonatomic, weak) UIButton *emotionBtn;
/** + 按钮*/
@property (nonatomic, weak) UIButton *addBtn;
/** 文本输入框*/
@property (nonatomic, weak) WLBaseTextField *textField;
/** 语音输入*/
@property (nonatomic, weak) WLChatToolBarVoiceField *voiceField;
/** 表情键盘*/
@property (nonatomic, strong) WLEmotionKeyboard *emotionKeyboard;
/** 是否在录音状态*/
@property (nonatomic, assign) BOOL isVoiceing;
/** 当前键盘是否为表情键盘*/
@property (nonatomic, assign) BOOL isEmotionKeyboard;
/** 是否正在切换键盘*/
@property (nonatomic, assign) BOOL isSwapKeyboarding;
@end

@implementation WLChatToolBar

- (WLEmotionKeyboard *)emotionKeyboard {
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [[WLEmotionKeyboard alloc] init];
        _emotionKeyboard.bounds = CGRectMake(0, 0, self.bounds.size.width, 220);
    }
    return _emotionKeyboard;
}

- (void)setupFlag {
    self.isSwapKeyboarding = NO;
    self.isEmotionKeyboard = NO;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, WLChatToolBarScreenSize.height - kToolBarH, WLChatToolBarScreenSize.width, kToolBarH);
        self.backgroundColor = [UIColor whiteColor];
        //顶部分割线
        UIView *divide = [[UIView alloc] init];
        divide.backgroundColor = [UIColor divideColor];
        divide.frame = CGRectMake(0, 0, WLChatToolBarScreenSize.height, 1);
        [self addSubview:divide];
        [self setupFlag];
        [self setupSubView];
        [self registNotification];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
/** 监听  观察者*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WLChatToolBarFrameDidChangeNotification object:nil userInfo:@{WLChatToolBarFrameDidChangeNotificationKey : [NSValue valueWithCGRect:self.frame]}];
}

#pragma mark -- 初始化

- (void)registNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //监听文本框的尺寸改变
    [center addObserver:self selector:@selector(textFieldFrameDidChanged:) name:WLBaseTextFieldFrameDidChangeNotification object:self.textField];
    [center addObserver:self.textField selector:@selector(deleteBackward) name:WLEmotionKeyboardDidDeleteNotification object:nil];
    [center addObserver:self selector:@selector(selectedEmotion:) name:WLEmotionKeyboardDidSelectedEmotionNotification object:nil];
    [center addObserver:self selector:@selector(sendMessage) name:WLEmotionKeyboardDidSendNotification object:nil];
}

- (void)setupSubView {
    
    // 文本输入框
    CGFloat textFieldX = kBtnW;
    CGFloat textFieldW = WLChatToolBarScreenSize.width - 2 * kBtnW;
    CGFloat textFieldY = kTextFieldPadding;
    CGFloat textFieldH = kToolBarH - 2 * kTextFieldPadding;
    WLBaseTextField *textField = [[WLBaseTextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH)];
    self.textField = textField;
    textField.delegate = self;
    [self addSubview:textField];
    
    //监听键盘位置改变
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // + 按钮
    CGFloat addBtnX = WLChatToolBarScreenSize.width - kBtnW;
    self.addBtn = [self addSubViewBtnWithX:addBtnX Y:0 image:@"chat_bottom_icon_add" highlightedImage:@"chat_bottom_icon_add_pressed" target:self action:@selector(addBtnClick) event:UIControlEventTouchUpInside];
    
    //表情按钮
    CGFloat emotionBtnX = self.addBtn.frame.origin.x - kBtnW;
    self.emotionBtn = [self addSubViewBtnWithX:emotionBtnX Y:0 image:@"chat_bottom_icon_expression" highlightedImage:@"chat_bottom_icon_expression_pressed" target:self action:@selector(emotionBtnClick) event:UIControlEventTouchUpInside];
    //语音按钮
    self.voiceBtn = [self addSubViewBtnWithX:0 Y:0 image:@"chat_bottom_icon_voice" highlightedImage:@"chat_bottom_icon_voice_pressed" target:self action:@selector(voiceBtnClick) event:UIControlEventTouchUpInside];
    
    //语音输入
    WLChatToolBarVoiceField *voiceField = [[WLChatToolBarVoiceField alloc] init];
    self.voiceField = voiceField;
    self.voiceField.frame = self.textField.frame;
    self.voiceField.hidden = YES;
    [self addSubview:voiceField];
    
}

#pragma mark -- textView 代理方法

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        [self sendMessage];
        
        return NO;
    }
    return YES;
}

#pragma mark -- 通知监听方法

- (void)textFieldFrameDidChanged:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[WLBaseTextFieldFrameDidChangeNotificationKey] CGRectValue];
    [self changeFrameWithTextFieldFrame:rect];
}

- (void)selectedEmotion:(NSNotification *)notification {
    WLEmotionModel *emotion = notification.userInfo[WLEmotionKeyboardDidSelectedEmotionNotificationKey];
    if (emotion.isGif) {
        if ([self.delegate respondsToSelector:@selector(chatToolBarDidSendEmotion:)]) {
            [self.delegate chatToolBarDidSendEmotion:emotion];
        }
    }
    else {
        [self.textField insertEmotion:emotion];
    }
}

- (void)sendMessage {
    NSString *text = self.textField.fullText;
    if (text != nil && text.length != 0) {
        [self sendMessage:text];
    }
    self.textField.attributedText = nil;
}

- (void)sendMessage:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(chatToolBarDidSendMessge:)]) {
        [self.delegate chatToolBarDidSendMessge:text];
    }
}

/** 根据文本输入框的frame 改变自身frame*/
- (void)changeFrameWithTextFieldFrame:(CGRect)rect {
    CGRect oldFrame = self.frame;
    CGFloat newH = rect.size.height + 2 * kTextFieldPadding;
    CGFloat newY = oldFrame.origin.y - (newH - oldFrame.size.height);
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = CGRectMake(oldFrame.origin.x, newY, oldFrame.size.width, newH);
    }];
}

- (void)keyboardFrameDidChanged:(NSNotification *)notification {
    if (self.isSwapKeyboarding) {
        self.isSwapKeyboarding = NO;
        return;
    }
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self changeFrameWithKeyBoardFrame:keyboardF];
}
/** 根据键盘的frame 改变自身frame*/
- (void)changeFrameWithKeyBoardFrame:(CGRect)keyboardF {
    CGSize toolBarSize = self.frame.size;
    CGRect newFrame = CGRectMake(0, keyboardF.origin.y - toolBarSize.height, toolBarSize.width, toolBarSize.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    }];
}
/** 重置自身frame*/
- (void)resetFrame {
    CGFloat offset = self.bounds.size.height - kToolBarH;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + offset, self.frame.size.width, kToolBarH);
    }];
}

#pragma mark -- 按钮点击响应方法
/** 语音按钮被点击*/
- (void)voiceBtnClick {
    NSString *image = nil;
    NSString *highlightedImage = nil;
    if (self.isVoiceing) {//语音输入状态  需转化为非语音输入状态
        image = @"chat_bottom_icon_voice";
        highlightedImage = @"chat_bottom_icon_voice_pressed";
        [self changeFrameWithTextFieldFrame:self.textField.frame];
        [self.textField becomeFirstResponder];
        
    } else {
        image = @"chat_bottom_icon_t";
        highlightedImage = @"chat_bottom_icon_t_pressed";
        [self resetFrame];
        [self endEditing:YES];
    }
    [self.voiceBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    self.isVoiceing = !self.isVoiceing;
    self.emotionBtn.hidden = !self.emotionBtn.hidden;
    self.textField.hidden = !self.textField.hidden;
    self.voiceField.hidden = !self.voiceField.hidden;
}

/** 表情按钮被点击*/
- (void)emotionBtnClick {
    NSString *image = nil;
    NSString *highlightedImage = nil;
    self.isSwapKeyboarding = YES;
    if (self.isEmotionKeyboard) {//表情输入状态  需转化为非普通输入状态
        image = @"chat_bottom_icon_expression";
        highlightedImage = @"chat_bottom_icon_expression_pressed";
        self.textField.inputView = nil;
        
    } else {
        image = @"chat_bottom_icon_keyboard";
        highlightedImage = @"chat_bottom_icon_keyboard_pressed";
        self.textField.inputView = self.emotionKeyboard;
        [self.textField postTextDidChangeNotification];
        
    }
    [self endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isSwapKeyboarding = NO;
        [self.textField becomeFirstResponder];
    });
    self.isEmotionKeyboard = !self.isEmotionKeyboard;
    [self.emotionBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionBtn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
}

/** 更多 + 按钮被点击*/
- (void)addBtnClick {
    
}

/** 添加一个按钮*/
- (UIButton *)addSubViewBtnWithX:(CGFloat)X Y:(CGFloat)Y image:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action event:(UIControlEvents)event {
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(X, Y, kBtnW, kBtnH);
    [btn addTarget:target action:action forControlEvents:event];
    [self addSubview:btn];
    return btn;
    
}

+ (instancetype)chatToolBar {
    return [[self alloc] init];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"frame" context:nil];
}


@end
