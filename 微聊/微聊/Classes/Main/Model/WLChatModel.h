//
//  WLChatModel.h
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WLChatModelTypeText = 0,//文本信息
    WLChatModelTypeGifEmotion = 1,//表情信息
    WLChatModelTypeImage = 2,//图片信息
    WLChatModelTypeVoice = 4,//语音信息
}WLChatModelType;

@class WLUserModel;
@interface WLChatModel : NSObject

@property (nonatomic, assign) NSUInteger m_id;

/** 聊天内容 如果为普通文字消息  对应的是聊天内容  如果为gif表情消息  对应的则是 gif表情所对应的文字*/
@property (nonatomic, copy) NSString *text;

/** 发送的用户*/
@property (nonatomic, strong) WLUserModel *user;
/** 接收的用户*/
@property (nonatomic, strong) WLUserModel *to_user;

/** 发送的时间*/
@property (nonatomic, copy) NSString *time;

/** 是否为当前用户发送*/
@property (nonatomic, assign) BOOL isMeSend;

/** 是否为gif表情信息*/
@property (nonatomic, assign) WLChatModelType type;

- (NSAttributedString *)attributedText;

@end
