//
//  WLDetailUserModel.h
//  微聊
//
//  Created by weimi on 15/8/20.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLUserModel.h"

@interface WLDetailUserModel : WLUserModel

/**
 *  年龄
 */
@property (nonatomic, assign) NSUInteger age;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  生日 Y-m-d
 */
@property (nonatomic, copy) NSString *birthday;
/**
 *  城市
 */
@property (nonatomic, copy) NSString *city;
/**
 *  是否为我的好友
 */

@end
