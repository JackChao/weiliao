//
//  WLNewFriendCellModel.h
//  微聊
//
//  Created by weimi on 15/8/19.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLUserModel;
@interface WLNewFriendCellModel : NSObject
/*
 "f_id": "好友请求消息ID",
 "text": "好友请求说明",
 "create_time": "创建时间",
 "from_user": {
 "uid": "用户名",
 "name": "昵称",
 "photo": "头像"
 }
 */
@property (nonatomic, strong) WLUserModel *from_user;
@property (nonatomic, assign) NSUInteger f_id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *create_time;

@end
