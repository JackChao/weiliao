//
//  WLStatusModel.h
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLUserModel;
@interface WLStatusModel : NSObject

/**
 *  状态ID
 */
@property (nonatomic, assign) NSUInteger s_id;
/**
 *  状态内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  图片地址
 */
@property (nonatomic, strong) NSArray *pics;
/**
 *  评论数
 */
@property (nonatomic, assign) NSUInteger count;
/**
 *  from_user
 */
@property (nonatomic, strong) WLUserModel *from_user;
/**
 *  状态内容 有属性的文字
 */
@property (nonatomic, strong) NSAttributedString *attributedText;

@end
