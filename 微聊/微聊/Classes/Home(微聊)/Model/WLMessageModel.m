//
//  WLHomeCellModel.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLMessageModel.h"
#import "MJExtension.h"
#import "NSString+ZGExtension.h"
#import "WLUserModel.h"
#import "WLUserTool.h"
@implementation WLMessageModel

+ (NSMutableArray *)messages {

    return [self objectArrayWithFile:WLMessageModelPath];
}


- (NSString *)timeWithCurrentTime {
    return [self.createTime timeStringWithcurrentTime];
}

- (void)setRemindCount:(NSUInteger)remindCount {
    _remindCount = remindCount;
}

- (NSString *)remindCountString {
    if (self.remindCount > 99) {
        return @"99";
    } else {
        return [NSString stringWithFormat:@"%zd", self.remindCount];
    }
}

@end
