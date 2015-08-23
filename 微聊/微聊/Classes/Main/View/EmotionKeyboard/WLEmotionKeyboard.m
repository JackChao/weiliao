//
//  WLEmotionKeyboard.m
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionKeyboard.h"
#import "WLEmotionKeyboardTabBar.h"
#import "WLEmotionListView.h"
#import "UIColor+ZGExtension.h"
#import "WLEmotionTool.h"
@interface WLEmotionKeyboard()<WLEmotionKeyboardTabBarDelegate>

/** 底部工具条*/
@property (nonatomic, weak) WLEmotionKeyboardTabBar *tabBar;
/** 米兔*/
@property (nonatomic, strong) WLEmotionListView *emotionMituList;
/** 章鱼*/
@property (nonatomic, strong) WLEmotionListView *emotionOctopusList;
/** 默认*/
@property (nonatomic, strong) WLEmotionListView *emotionDefaultList;
/** 当前选中的表情类别*/
@property (nonatomic, weak) WLEmotionListView *selectedList;


@end

@implementation WLEmotionKeyboard
#pragma mark -- 懒加载
- (WLEmotionListView *)emotionDefaultList {
    if (_emotionDefaultList == nil) {
        _emotionDefaultList = [[WLEmotionListView alloc] init];
        _emotionDefaultList.emotions = [WLEmotionTool defaultEmotions];
        //_emotionDefaultList.backgroundColor = [UIColor randomColor];
    }
    return _emotionDefaultList;
}
- (WLEmotionListView *)emotionMituList {
    if (_emotionMituList == nil) {
        _emotionMituList = [[WLEmotionListView alloc] init];
        _emotionMituList.emotions = [WLEmotionTool mituEmotions];
        //_emotionMituList.backgroundColor = [UIColor randomColor];
    }
    return _emotionMituList;
}
- (WLEmotionListView *)emotionOctopusList {
    if (_emotionOctopusList == nil) {
        _emotionOctopusList = [[WLEmotionListView alloc] init];
        _emotionOctopusList.emotions = [WLEmotionTool octopusEmotions];
       //_emotionOctopusList.backgroundColor = [UIColor randomColor];
    }
    return _emotionOctopusList;
}

- (void)setSelectedList:(WLEmotionListView *)selectedList {
    [_selectedList removeFromSuperview];
    _selectedList = selectedList;
    [self addSubview:selectedList];
}

#pragma mark -- 实例化方法

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTabBar];
        self.selectedList = self.emotionDefaultList;
        self.backgroundColor = [UIColor divideColor];
    }
    return self;
}
- (instancetype)initWithKeyboardType:(WLEmotionKeyboardType)keyboardType {
    if (self = [super init]) {
        _keyboardType = keyboardType;
        self.tabBar.tabBarType = (WLEmotionKeyboardTabBarType)_keyboardType;
    }
    return self;
}

+ (instancetype)emotionKeyboardWithKeyboardType:(WLEmotionKeyboardType)keyboardType {
    return [[self alloc] initWithKeyboardType:keyboardType];
}

- (void)setupTabBar {
    WLEmotionKeyboardTabBar *tabBar = [[WLEmotionKeyboardTabBar alloc] init];
    self.tabBar = tabBar;
    self.tabBar.delegate = self;
    [self addSubview:tabBar];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //设置工具条 frame
    CGFloat tabBarX = 0;
    CGFloat tabBarH = 37;
    CGFloat tabBarY = self.bounds.size.height - tabBarH;
    CGFloat tabBarW = self.bounds.size.width;
    self.tabBar.frame = CGRectMake(tabBarX, tabBarY, tabBarW, tabBarH);
    //设置表情列表Frame
    CGFloat selectedListX = 0;
    CGFloat selectedListH = self.bounds.size.height - tabBarH - 2;
    CGFloat selectedListY = 1;
    CGFloat selectedListW = self.bounds.size.width;
    self.selectedList.frame = CGRectMake(selectedListX, selectedListY, selectedListW, selectedListH);
}

#pragma mark --emotionKeyboardTabBar 代理方法
- (void)emotionKeyboardTabBar:(WLEmotionKeyboardTabBar *)tabBar tabBarButtonDidClick:(WLEmotionKeyboardTabBarButtonType)type  {
    switch (type) {
        case WLEmotionKeyboardTabBarButtonTypeDefault:
            self.selectedList = self.emotionDefaultList;
            break;
        case WLEmotionKeyboardTabBarButtonTypeMitu:
            self.selectedList = self.emotionMituList;
            break;
        case WLEmotionKeyboardTabBarButtonTypeOctopus:
            self.selectedList = self.emotionOctopusList;
            break;
    }
}

@end
