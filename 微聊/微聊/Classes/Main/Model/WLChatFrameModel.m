//
//  WLChatFrameModel.m
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatFrameModel.h"
#import "WLChatModel.h"
#import "WLChatCellConst.h"
@implementation WLChatFrameModel

- (void)setChat:(WLChatModel *)chat {
    _chat = chat;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    //时间frame
    CGFloat timeLabelX = 0;
    CGFloat timeLabelY = WLChatCellPadding;
    CGFloat timeLabelH = 20;
    CGFloat timeLabelW = screenW;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    //头像frame
    
    if (!chat.isMeSend) {//计算头像
        CGFloat photoViewX = WLChatCellPadding;
        CGFloat photoViewY = CGRectGetMaxY(self.timeLabelF) + WLChatCellPadding;
        self.photoViewF = CGRectMake(photoViewX, photoViewY, WLChatCellPhotoViewWH, WLChatCellPhotoViewWH);
    }
    
    
    //聊天内容frame
    
    if (chat.type == WLChatModelTypeGifEmotion) {//为gif 表情类型
        CGFloat chatContentViewX = 0;
        CGFloat chatContentViewY = CGRectGetMaxY(self.timeLabelF) + WLChatCellPadding;
        CGFloat chatContentViewW = WLChatCellGifEmotionViewWH;
        CGFloat chatContentViewH = WLChatCellGifEmotionViewWH;
        CGFloat gifViewX = 0;
        CGFloat gifViewY = 0;
        if (!chat.isMeSend) {
            chatContentViewX = CGRectGetMaxX(self.photoViewF) + WLChatCellPadding;
            //gifViewX = WLChatCellContentViewPaddingH + 3;
        } else {
            chatContentViewX = screenW - WLChatCellPadding - chatContentViewW;
            //gifViewX = WLChatCellContentViewPaddingH - 3;
        }
        self.gifEmotionViewF = CGRectMake(gifViewX, gifViewY, WLChatCellGifEmotionViewWH, WLChatCellGifEmotionViewWH);
        self.chatContentViewF = CGRectMake(chatContentViewX, chatContentViewY, chatContentViewW, chatContentViewH);
        
    } else { // 文字消息
        CGFloat textX = 0;
        CGFloat textY = CGRectGetMaxY(self.timeLabelF) + WLChatCellPadding;
        CGSize textSize = [chat.attributedText boundingRectWithSize:CGSizeMake(screenW - 2 * (WLChatCellPadding + WLChatCellPhotoViewWH + WLChatCellContentViewPaddingH), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        textSize.width += 2 * WLChatCellContentViewPaddingH;
        textSize.height += 2 * WLChatCellContentViewPaddingV;
        //** 注意 textView 位于  chatContentView里面  计算X, Y需注意
        CGFloat textViewX = WLChatCellContentViewPaddingH;
        CGFloat textViewY = WLChatCellContentViewPaddingV - 1;
        CGFloat textViewW = textSize.width - 2 * WLChatCellContentViewPaddingH + 10;
        CGFloat textViewH = textSize.height - 2 * WLChatCellContentViewPaddingV;
        if (!chat.isMeSend) {
            textX = CGRectGetMaxX(self.photoViewF) + WLChatCellPadding;
            textViewX += 3;
        } else {
            textViewX -= 3;
            textX = screenW - WLChatCellPadding - textSize.width;
        }
        self.textViewF = CGRectMake(textViewX, textViewY, textViewW, textViewH);
        self.chatContentViewF = CGRectMake(textX, textY, textSize.width, textSize.height);
    }
    self.height = MAX(CGRectGetMaxY(self.photoViewF), CGRectGetMaxY(self.chatContentViewF));
}

@end
