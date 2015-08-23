//
//  WLContactCellModel.m
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLContactCellFriendModel.h"
#import "MJExtension.h"
#import "WLUserModel.h"
@implementation WLContactCellFriendModel
/**
 *  通过一个字典数字创建一个包含WLContactCellFriendModel的数组
 */
+ (NSMutableArray *)contactCellFriendsWithArray:(NSArray *)dictArray {
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *users = [WLUserModel objectArrayWithKeyValuesArray:dictArray];
    for (WLUserModel *user in users) {
        WLContactCellFriendModel *model = [[WLContactCellFriendModel alloc] init];
        model.user = user;
        [arrayM addObject:model];
    }
    return arrayM;
}
@end
