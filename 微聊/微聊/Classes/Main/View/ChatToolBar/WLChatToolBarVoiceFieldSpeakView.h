//
//  WLChatToolBarVoiceFieldSpeakView.h
//  微聊
//
//  Created by weimi on 15/8/1.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WLChatToolBarVoiceFieldSpeakViewTypeNormal = 1,
    WLChatToolBarVoiceFieldSpeakViewTypeDelete
}WLChatToolBarVoiceFieldSpeakViewType;

@interface WLChatToolBarVoiceFieldSpeakView : UIView

@property (nonatomic, assign)WLChatToolBarVoiceFieldSpeakViewType type;

- (void)show;
- (void)remove;
@end
