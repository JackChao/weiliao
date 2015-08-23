//
//  WLEmotionPageView.m
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionPageView.h"
#import "WLEmotionModel.h"
#import "WLEmotionView.h"
#import "WLEmotionKeyboardNotificationConst.h"
#import "WLEmotionPopView.h"
/** gif 表情 最大行数*/
const int WLEmotionPageViewGifRowMaxCount = 2;
/** gif 表情 最大列数*/
const int WLEmotionPageViewGifColMaxCount = 4;
/** gif 表情 一页最大数量*/
const int WLEmotionPageViewGifPageMaxCout = WLEmotionPageViewGifRowMaxCount * WLEmotionPageViewGifColMaxCount;

/** 普通 表情 最大行数*/
const int WLEmotionPageViewDefaultRowMaxCount = 3;
/** 普通 表情 最大列数*/
const int WLEmotionPageViewDefaultColMaxCount = 6;
/** 普通 表情 一页最大数量*/
const int WLEmotionPageViewDefaultPageMaxCount = WLEmotionPageViewDefaultRowMaxCount * WLEmotionPageViewDefaultColMaxCount - 1;

const CGFloat WLEmotionPageViewPadding = 10;

@interface WLEmotionPageView()

@property (nonatomic, strong) NSMutableArray *emotionViews;
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, strong) WLEmotionPopView *popView;
/** 表情列数*/
@property (nonatomic, assign) int maxCol;
/** 表情行数*/
@property (nonatomic, assign) int maxRow;
@end


@implementation WLEmotionPageView

#pragma mark -- 懒加载
- (WLEmotionPopView *)popView {
    if (_popView == nil) {
        _popView = [[WLEmotionPopView alloc] init];
    }
    return _popView;
}

- (NSMutableArray *)emotionViews {
    if (_emotionViews == nil) {
        _emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        _deleteBtn = deleteBtn;
        [deleteBtn setImage:[UIImage imageNamed:@"chat_expression_icon_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
    return _deleteBtn;
}

#pragma mark --setter
- (void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    //计算  行 列数
    WLEmotionModel *emotion1 = [emotions firstObject];
    self.maxCol = WLEmotionPageViewDefaultColMaxCount;
    self.maxRow = WLEmotionPageViewDefaultRowMaxCount;
    if (emotion1.isGif) {//是gif表情
        self.maxCol = WLEmotionPageViewGifColMaxCount;
        self.maxRow = WLEmotionPageViewGifRowMaxCount;
        self.deleteBtn.hidden = YES;
    } else {
        self.deleteBtn.hidden = NO;
    }
    
    //清除所有表情
    [self clearAllEmorions];
    NSUInteger count = emotions.count;
    for (NSUInteger i = 0; i < count; i++) {
        WLEmotionModel *emotion = emotions[i];
        WLEmotionView *emotionView = [[WLEmotionView alloc] init];
        emotionView.emotion = emotion;
        
        [emotionView addTarget:self action:@selector(emotionViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.emotionViews addObject:emotionView];
        [self addSubview:emotionView];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat MaxW = self.bounds.size.width - 2 * WLEmotionPageViewPadding;
    CGFloat MaxH = self.bounds.size.height - WLEmotionPageViewPadding;
    
    //设置删除按钮
    CGFloat emotionViewX = 0;
    CGFloat emotionViewY = 0;
    CGFloat emotionViewW = MaxW / self.maxCol;
    CGFloat emotionViewH = MaxH / self.maxRow;
    NSUInteger count = self.emotionViews.count;
    for (NSUInteger i = 0; i < count; i++) {
        emotionViewX = (i % self.maxCol) * emotionViewW + WLEmotionPageViewPadding;
        emotionViewY = (i / self.maxCol) * emotionViewH + WLEmotionPageViewPadding;
        WLEmotionView *emotionView = self.emotionViews[i];
        emotionView.frame = CGRectMake(emotionViewX, emotionViewY, emotionViewW, emotionViewH);
    }
    //设置删除按钮
    CGFloat deleteBtnW = emotionViewW;
    CGFloat deleteBtnH = emotionViewH;
    CGFloat deleteBtnX = (self.maxCol - 1) * deleteBtnW + WLEmotionPageViewPadding;
    CGFloat deleteBtnY = (self.maxRow - 1) * deleteBtnH + WLEmotionPageViewPadding;
    self.deleteBtn.frame = CGRectMake(deleteBtnX, deleteBtnY, deleteBtnW, deleteBtnH);
}

- (void)clearAllEmorions {
    for (WLEmotionView *emotionView in self.emotionViews) {
        [emotionView removeFromSuperview];
    }
    [self.emotionViews removeAllObjects];
}

#pragma mark -- 按钮点击事件处理

- (void)deleteBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:WLEmotionKeyboardDidDeleteNotification object:nil];
}

- (void)emotionViewDidClick:(WLEmotionView *)emotionView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WLEmotionKeyboardDidSelectedEmotionNotification object:nil userInfo:@{WLEmotionKeyboardDidSelectedEmotionNotificationKey : emotionView.emotion}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

#pragma mark -- 长按处理方法
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self];
    WLEmotionView *emotionView = [self emotionViewWithPoint:point];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            if (emotionView) {
                self.popView.emotion = emotionView.emotion;
                [self.popView showWithView:emotionView];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (emotionView) {
                self.popView.emotion = emotionView.emotion;
                [self.popView showWithView:emotionView];
            } else {
                [self.popView dismiss];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (emotionView) {
                [self emotionViewDidClick:emotionView];
            }
            [self.popView dismiss];
            break;
        }
            
        default:
            [self.popView dismiss];
            break;
    }
}

- (WLEmotionView *)emotionViewWithPoint:(CGPoint)point {
    for (WLEmotionView *emotionView in self.emotionViews) {
        if (CGRectContainsPoint(emotionView.frame, point)) {
            return emotionView;
        }
    }
    return nil;
}
@end
