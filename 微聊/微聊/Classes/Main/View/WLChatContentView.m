//
//  WLChatContentView.m
//  微聊
//
//  Created by weimi on 15/7/30.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatContentView.h"
#import "WLChatCellConst.h"
#import "WLChatModel.h"
#import "WLEmotionTool.h"
#import "WLChatFrameModel.h"
@interface WLChatContentView()
/** 文字 容器*/
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, assign) CGFloat offsetX;
/** gif表情*/
@property (nonatomic, weak) UIImageView *gifEmotionView;

@end

@implementation WLChatContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setChatF:(WLChatFrameModel *)chatF {
    _chatF = chatF;
    WLChatModel *chat = chatF.chat;
    if(chat.type == WLChatModelTypeGifEmotion) {//为 gif
        self.textView.hidden = YES;
        self.gifEmotionView.hidden = NO;
        self.gifEmotionView.image = [WLEmotionTool gifImageWithEmotion:[WLEmotionTool emotionWithZh_Hans:chat.text]];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateSelected];
    } else {
        self.gifEmotionView.hidden = YES;
        self.gifEmotionView.image = nil;
        self.textView.hidden = NO;
        self.textView.attributedText = chat.attributedText;
    }
    
    if (chat.isMeSend) {//针对气泡  做的位移
        self.offsetX = -3;
    } else {
        self.offsetX = 3;
    }
    [self setNeedsLayout];
}

- (UIImageView *)gifEmotionView {
    if (_gifEmotionView == nil) {
        UIImageView *gifEmotionView = [[UIImageView alloc] init];
        _gifEmotionView = gifEmotionView;
        [self addSubview:gifEmotionView];
    }
    return _gifEmotionView;
}


- (UITextView *)textView {
    if (_textView == nil) {
        UITextView *textView = [[UITextView alloc] init];
        _textView = textView;
        textView.userInteractionEnabled = NO;
        textView.backgroundColor = [UIColor clearColor];
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.contentInset = UIEdgeInsetsMake(0, -5, 0, -5);
        textView.scrollEnabled = NO;
        [self addSubview:textView];
    }
    return _textView;
}


#pragma mark -- 长按响应方法
- (void)longPress:(UILongPressGestureRecognizer *)press {
    switch (press.state) {
        case UIGestureRecognizerStateBegan:{
            self.selected = YES;
            [self shouMenu];
            break;
        }
        case UIGestureRecognizerStateChanged:
            break;
        default:
            self.selected = NO;
            break;
    }
}
#pragma mark -- 操作菜单处理
/** 显示操作菜单*/
- (void)shouMenu {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(repostContent)];
    UIMenuItem *item3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteContent)];
    UIMenuItem *item4 = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(moreOperate)];
    if (self.chatF.chat.type == WLChatModelTypeText) {
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyContent)];
        menu.menuItems = @[item1, item2, item3, item4];
    } else {
        menu.menuItems = @[item2, item3, item4];
    }
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGFloat X = rect.size.width * 0.5;
    CGFloat Y = 0;
    if (rect.origin.y < 44) {
        CGFloat MaxY = [UIScreen mainScreen].bounds.size.height - 44;
        if (CGRectGetMaxY(rect) > MaxY) {
            Y = -rect.origin.y + MaxY * 0.65;
        } else {
            Y = rect.size.height;
        }
        [menu setArrowDirection:UIMenuControllerArrowUp];
    } else {
        [menu setArrowDirection:UIMenuControllerArrowDown];
    }
    [menu setTargetRect:CGRectMake(X, Y, 0, 0) inView:self];
    [self becomeFirstResponder];
    [menu setMenuVisible:YES animated:YES];
}

-(BOOL) canBecomeFirstResponder{
    return YES;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    if ([self respondsToSelector:action]) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

/** 选项被点击*/
- (void)operateClick:(WLChatContentViewMenuOperateType)type {

    if([self.delegate respondsToSelector:@selector(chatContentView:menuDidClick:)]) {
        [self.delegate chatContentView:self menuDidClick:type];
        
    }
}

/** 操作菜单 复制 被点击*/
- (void)copyContent {
    [self operateClick:WLChatContentViewMenuOperateTypeCopy];
}

/** 操作菜单 转发 被点击*/
- (void)repostContent {
    [self operateClick:WLChatContentViewMenuOperateTypeReopst];
}

/** 操作菜单 删除 被点击*/
- (void)deleteContent {
    [self operateClick:WLChatContentViewMenuOperateTypeDelete];
}

/** 操作菜单 更多 被点击*/
- (void)moreOperate {
    [self operateClick:WLChatContentViewMenuOperateTypeMore];
    //NSLog(@"%@", NSStringFromUIEdgeInsets(self.textView.contentInset));
}

#pragma mark -- 重写系统方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.chatF.chat.type == WLChatModelTypeGifEmotion) {
        self.gifEmotionView.frame = self.chatF.gifEmotionViewF;
    } else {
        self.textView.frame = self.chatF.textViewF;
    }
    
}

@end
