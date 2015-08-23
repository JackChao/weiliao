//
//  WLEmotionKeyboardTabBar.h
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WLEmotionKeyboardTabBarButtonTypeDefault,//默认
    WLEmotionKeyboardTabBarButtonTypeMitu,//米兔
    WLEmotionKeyboardTabBarButtonTypeOctopus //章鱼
}WLEmotionKeyboardTabBarButtonType;

typedef enum {
    WLEmotionKeyboardTabBarTypeDefault = 0,
    WLEmotionKeyboardTabBarTypeSimple
}WLEmotionKeyboardTabBarType;

@class WLEmotionKeyboardTabBar;

@protocol WLEmotionKeyboardTabBarDelegate <NSObject>

@optional
/** 工具条 表情分类 按钮被点击*/
- (void)emotionKeyboardTabBar:(WLEmotionKeyboardTabBar *)tabBar tabBarButtonDidClick:(WLEmotionKeyboardTabBarButtonType)type;

@end

@interface WLEmotionKeyboardTabBar : UIView

@property (nonatomic, weak) id<WLEmotionKeyboardTabBarDelegate> delegate;
@property (nonatomic, assign) WLEmotionKeyboardTabBarType tabBarType;

@end
