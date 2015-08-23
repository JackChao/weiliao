//
//  WLChatFrameModel.h
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WLChatModel;
@interface WLChatFrameModel : NSObject

@property (nonatomic, strong) WLChatModel *chat;
@property (nonatomic, assign) CGRect chatContentViewF;
@property (nonatomic, assign) CGRect photoViewF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect gifEmotionViewF;
@property (nonatomic, assign) CGRect textViewF;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL hideTime;

@end
