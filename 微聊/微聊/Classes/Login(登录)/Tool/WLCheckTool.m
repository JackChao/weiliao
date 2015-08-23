//
//  WLCheckTool.m
//  微聊
//
//  Created by weimi on 15/8/6.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLCheckTool.h"
const int WLCheckToolTextFieldMaxLength = 16;

const int WLCheckToolUsernameMaxLength = 16;
const int WLCheckToolPasswordMaxlength = 16;

const int WLCheckToolUsernameMinLength = 6;
const int WLCheckToolPasswordMinlength = 6;

@implementation WLCheckTool

+ (NSString *)check:(NSString *)username pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2 {
    NSString *message = nil;
    if (username == nil || pwd1 == nil || pwd2 == nil) {
        message = @"填写不整";
    }
    if (username.length < WLCheckToolUsernameMinLength || username.length > WLCheckToolUsernameMaxLength) {
        message = @"用户名填写有误";
    } else if (![pwd2 isEqualToString:pwd1] || pwd1.length < WLCheckToolPasswordMinlength || pwd1.length > WLCheckToolPasswordMaxlength) {
        message = @"密码填写有误";
    }
    return message;
}

+ (NSString *)loginCheck:(NSString *)username pwd:(NSString *)pwd {
    NSString *message = nil;
    message = [self check:username pwd1:pwd pwd2:pwd];
    return message;
}

+ (NSString *)registerCheck:(NSString *)username pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2 {
    NSString *message = nil;
    message = [self check:username pwd1:pwd1 pwd2:pwd2];
    return message;
}

@end
