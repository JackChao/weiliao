//
//  WLUserModel.h
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLUserModel : NSObject<NSCoding>

/** 用户头像*/
@property (nonatomic, copy) NSString *photo;
/** 用户昵称*/
@property (nonatomic, copy) NSString *name;
/** 用户uid(账号)*/
@property (nonatomic, copy) NSString *uid;

@end
