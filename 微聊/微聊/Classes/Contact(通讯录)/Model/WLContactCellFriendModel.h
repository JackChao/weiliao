//
//  WLContactCellModel.h
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

/**联系人列表 好友数据模型*/

#import "WLCellBaseModel.h"
@class WLUserModel;
@interface WLContactCellFriendModel : WLCellBaseModel

@property (nonatomic, strong) WLUserModel *user;
/** 备注*/
@property (nonatomic, copy) NSString *remark;
/**
 *  通过一个WLUserModel字典数字创建一个包含WLContactCellFriendModel的数组
 */
+ (NSMutableArray *)contactCellFriendsWithArray:(NSArray *)dictArray;

@end
