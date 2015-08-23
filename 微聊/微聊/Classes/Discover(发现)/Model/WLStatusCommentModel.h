//
//  WLStatusCommentModel.h
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLUserModel;
@interface WLStatusCommentModel : NSObject

/**
 *  评论ID
 */
@property (nonatomic, assign) NSUInteger c_id;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  from_user
 */
@property (nonatomic, strong) WLUserModel *from_user;
/**
 *  评论内容 有属性的文字
 */
@property (nonatomic, strong) NSAttributedString *attributedText;

@end
