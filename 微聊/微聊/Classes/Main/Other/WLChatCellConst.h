//
//  WLChatCellConst.h
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

/** MessageCell 聊天内容按钮的字体*/
#define WLChatCellContentViewFont [UIFont systemFontOfSize:15.0]

/** MessageCell 创建时间标签的字体*/
#define WLChatCellTimeLabelFont [UIFont systemFontOfSize:10.0]


/** ChatCell 头像的宽高*/
extern const double WLChatCellPhotoViewWH;

/** ChatCell padding*/
extern const double WLChatCellPadding;

/** ChatCell ContentBtn padding  垂直*/
extern const double WLChatCellContentViewPaddingV;

/** ChatCell ContentBtn padding 水平*/
extern const double WLChatCellContentViewPaddingH;
/** ChatCell gif表情的宽高*/
extern const double WLChatCellGifEmotionViewWH;

@interface WLChatCellConst : NSObject

@end
