//
//  WLUserTool.m
//  微聊
//
//  Created by weimi on 15/8/4.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLUserTool.h"
#import "WLUserModel.h"

static WLUserModel *_currentUser = nil;

#define UserPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserInfo"]


@implementation WLUserTool

+ (WLUserModel *)currentUser {
    if (_currentUser == nil) {
        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:UserPath];
    }
    return _currentUser;
}

+ (void)saveUser:(WLUserModel *)user {
    [NSKeyedArchiver archiveRootObject:user toFile:UserPath];
    _currentUser = user;
}

+ (void)saveUserWithDict:(NSDictionary *)userDict {
    WLUserModel *user = [[WLUserModel alloc] init];
    user.name = userDict[@"name"];
    user.uid = userDict[@"uid"];
    user.photo = userDict[@"photo"];
    [WLUserTool saveUser:user];
}

+ (void)logoutCurrentUser {
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:UserPath error:nil];
}

@end
