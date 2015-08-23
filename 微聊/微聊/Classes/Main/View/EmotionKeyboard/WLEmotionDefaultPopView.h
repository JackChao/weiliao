//
//  WLEmotionDefaultPopView.h
//  微聊
//
//  Created by weimi on 15/8/3.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLEmotionModel;
@interface WLEmotionDefaultPopView : UIView

@property (nonatomic, strong)WLEmotionModel *emotion;

+ (instancetype)emotionDefaultPopView;

@end
