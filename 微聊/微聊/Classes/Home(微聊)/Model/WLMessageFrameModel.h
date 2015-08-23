//
//  WLMessageModelFrame.h
//  微聊
//
//  Created by weimi on 15/7/16.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WLMessageModel;

@interface WLMessageFrameModel : NSObject

@property (nonatomic, strong) WLMessageModel *message;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect detailLabelF;
@property (nonatomic, assign) CGRect photoViewF;
@property (nonatomic, assign) CGRect createTimeLabelF;
@property (nonatomic, assign) CGRect remindViewF;
@property (nonatomic, assign) CGFloat height;

+ (NSMutableArray *)messageFrames;

/** 根据其他模型更新本身, 模型的user uid 一致*/
- (void)updateWithOtherMessageModel:(WLMessageModel *)other;

@end
