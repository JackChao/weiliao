//
//  WLEmotionPopView.h
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLEmotionModel;
@interface WLEmotionPopView : UIView

@property (nonatomic, strong) WLEmotionModel *emotion;

/** 根据View显示 popView*/
- (void)showWithView:(UIView *)view;
- (void)dismiss;
@end
