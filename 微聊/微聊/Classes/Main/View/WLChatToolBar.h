//
//  WLChatToolBar.h
//  微聊
//
//  Created by weimi on 15/7/30.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WLChatToolBarFrameDidChangeNotification @"WLChatToolBarFrameDidChangeNotification"
#define WLChatToolBarFrameDidChangeNotificationKey @"WLChatToolBarFrameDidChangeNotificationKey"
extern const double kToolBarH;

@class WLEmotionModel;
@protocol WLChatToolBarDelegate <NSObject>

@optional

- (void)chatToolBarDidSendMessge:(NSString *)text;
- (void)chatToolBarDidSendEmotion:(WLEmotionModel *)emotion;

@end

@interface WLChatToolBar : UIView

@property (nonatomic, weak) id<WLChatToolBarDelegate> delegate;

+ (instancetype)chatToolBar;

@end
