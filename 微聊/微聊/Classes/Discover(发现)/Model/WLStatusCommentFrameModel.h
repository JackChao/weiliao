//
//  WLStatusFrameModel.h
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WLStatusCommentModel;
@interface WLStatusCommentFrameModel : NSObject
@property (nonatomic, assign) CGRect commentViewF;
@property (nonatomic, assign) CGRect photoViewF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect textViewF;
@property (nonatomic, strong) WLStatusCommentModel *comment;
@property (nonatomic, assign) CGFloat height;
@end
