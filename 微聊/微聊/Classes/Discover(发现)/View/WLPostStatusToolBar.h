//
//  WLPostStatusToolBar.h
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    WLPostStatusToolBarEmotionBtnTypeFace,//笑脸样式
    WLPostStatusToolBarEmotionBtnTypeKeyboard,//键盘样式
}WLPostStatusToolBarEmotionBtnType;

@class WLPostStatusToolBar;

@protocol WLPostStatusToolBarDelegate <NSObject>

@optional
- (void)postStatusToolBarEmotionBtnDidClick:(WLPostStatusToolBar *)toolBar;

@end

@interface WLPostStatusToolBar : UIView

@property (nonatomic, assign) WLPostStatusToolBarEmotionBtnType emotionBtnType;
@property (nonatomic, weak) id<WLPostStatusToolBarDelegate> delegate;

@end
