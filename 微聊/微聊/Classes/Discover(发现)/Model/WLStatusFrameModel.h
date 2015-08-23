//
//  WLStatusFrameModel.h
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WLStatusModel;
@interface WLStatusFrameModel : NSObject
@property (nonatomic, assign) CGRect statusViewF;
@property (nonatomic, assign) CGRect photoViewF;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect textViewF;
@property (nonatomic, assign) CGRect statusImageViewF;
@property (nonatomic, assign) CGRect commentLabelF;
@property (nonatomic, strong) WLStatusModel *status;
@property (nonatomic, assign) CGFloat height;
@end
