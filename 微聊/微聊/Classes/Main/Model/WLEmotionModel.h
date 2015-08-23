//
//  WLEmotionDefaultModel.h
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLEmotionModel : NSObject

/** 表情代表的文字*/
@property (nonatomic, copy) NSString *zh_Hans;
/** 表情对应的图片*/
@property (nonatomic, copy) NSString *image;
/** 表情类型*/
@property (nonatomic, assign) BOOL isGif;

@end
