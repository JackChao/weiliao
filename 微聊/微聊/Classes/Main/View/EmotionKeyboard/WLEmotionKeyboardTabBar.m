//
//  WLEmotionKeyboardTabBar.m
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionKeyboardTabBar.h"
#import "UIColor+ZGExtension.h"
#import "WLBaseTextField.h"
#import "WLEmotionKeyboardNotificationConst.h"

@interface WLEmotionKeyboardTabBar()

@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) UIButton *sendBtn;
/** 用于遮住表情分类按钮 --- sendBtn 之间的空隙*/
@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation WLEmotionKeyboardTabBar

#pragma mark -- 懒加载
- (NSMutableArray *)tabBarButtons {
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (UIButton *)sendBtn {
    if (_sendBtn == nil) {
        UIButton *sendBtn = [[UIButton alloc] init];
        _sendBtn = sendBtn;
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [sendBtn setBackgroundImage:[UIImage imageNamed:@"all_list_button_red"] forState:UIControlStateNormal];
        sendBtn.backgroundColor = [UIColor orangeColor];
        [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
    }
    return _sendBtn;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        UIView *maskView = [[UIView alloc] init];
        _maskView = maskView;
        maskView.backgroundColor = [UIColor whiteColor];
        [self addSubview:maskView];
    }
    return _maskView;
}

- (void)setSelectedBtn:(UIButton *)selectedBtn {
    _selectedBtn.selected = NO;
    _selectedBtn.backgroundColor = [UIColor whiteColor];
    _selectedBtn = selectedBtn;
    _selectedBtn.selected = YES;
    _selectedBtn.backgroundColor = [UIColor colorWithR:214.0 g:214.0 b:214.0 alpha:0.7];
}

- (void)setTabBarType:(WLEmotionKeyboardTabBarType)tabBarType {
    _tabBarType = tabBarType;
    [self setNeedsLayout];
}

#pragma mark -- 通知监听方法
- (void)textFieldTextDidChange:(NSNotification *)notification {
    NSAttributedString *attr = notification.userInfo[WLBaseTextFieldTextDidChangeNotificationKey];
    if (attr == nil || attr.length == 0) {
        self.sendBtn.enabled = NO;
    } else {
        self.sendBtn.enabled = YES;
    }
    
}

#pragma mark -- init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tabBarType = WLEmotionKeyboardTabBarTypeDefault;
        [self setupSubView];
        [self registNotification];
    }
    return self;
}

#pragma mark --初始化
/** 监听通知*/
- (void)registNotification {
    // 监听 textField text改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:WLBaseTextFieldTextDidChangeNotification object:nil];
}
/** 设置subuView*/
- (void)setupSubView {
    UIButton *defaultBtn = [self addTabBarButton:@"smilies_bottom_icon_00" type:WLEmotionKeyboardTabBarButtonTypeDefault];
    [self tabBarButtonClick:defaultBtn];
    [self addTabBarButton:@"smilies_bottom_icon_23" type:WLEmotionKeyboardTabBarButtonTypeMitu];
    [self addTabBarButton:@"smilies_bottom_icon_325" type:WLEmotionKeyboardTabBarButtonTypeOctopus];
    
}

- (UIButton *)addTabBarButton:(NSString *)image type:(WLEmotionKeyboardTabBarButtonType)type {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.tag = type;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarButtons addObject:btn];
    [self addSubview:btn];
    return btn;
}
#pragma mark -- 按钮点击
- (void)tabBarButtonClick:(UIButton *)btn {
    WLEmotionKeyboardTabBarButtonType type = (WLEmotionKeyboardTabBarButtonType)btn.tag;
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(emotionKeyboardTabBar:tabBarButtonDidClick:)]) {
        [self.delegate emotionKeyboardTabBar:self tabBarButtonDidClick:type];
    }
}

- (void)sendBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:WLEmotionKeyboardDidSendNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat MaxH = self.bounds.size.height;
    CGFloat MaxW = self.bounds.size.width;
    NSUInteger count = self.tabBarButtons.count;
    CGFloat btnX = 0;
    CGFloat btnH = MaxH;
    CGFloat btnW = 60.0;
    if (self.tabBarType == WLEmotionKeyboardTabBarTypeSimple) {//tabBar 简单样式
        for (int i = 0; i < count; i++) {
            UIButton *btn = self.tabBarButtons[i];
            if (i != 0) {
                btn.hidden = YES;
                continue;
            }
            btnX = (btnW + 1) * i;
            btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        }
        CGFloat maskViewX = btnW + 1;
        CGFloat maskViewW = MaxW - btnW - 1;
        self.maskView.frame = CGRectMake(maskViewX, 0, maskViewW, MaxH);
        return;
    }
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.tabBarButtons[i];
        btn.hidden = NO;
        btnX = (btnW + 1) * i;
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
    }
    CGFloat maskViewX = btnX + btnW + 1;
    CGFloat maskViewW = 0;
    if (self.sendBtn.hidden) {
        maskViewW = MaxW - maskViewX;
    } else {
        CGFloat sendX = MaxW - btnW;
        maskViewW = MaxW - maskViewX - btnW - 1;
        self.sendBtn.frame = CGRectMake(sendX, 0, btnW, MaxH);
    }
    self.maskView.frame = CGRectMake(maskViewX, 0, maskViewW, MaxH);
}

#pragma mark -- dealloc  移除通知
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
