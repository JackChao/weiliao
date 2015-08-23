//
//  WLUserTool.h
//  微聊
//
//  Created by weimi on 15/8/4.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLUserModel;
@interface WLUserTool : NSObject
/**
 *  获得当前登录用户
 */
+ (WLUserModel *)currentUser;
/**
 *  保存当前登录用户
 */
+ (void)saveUser:(WLUserModel *)user;
/**
 *  保存当前登录用户,字典
 */
+ (void)saveUserWithDict:(NSDictionary *)userDict;
/**
 *  退出当前登录的用户
 */
+ (void)logoutCurrentUser;

@end
