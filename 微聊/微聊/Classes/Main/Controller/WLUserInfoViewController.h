//
//  WLUserInfoViewController.h
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    WLUserInfoViewControllerTypeSelf,//查看自己信息
    WLUserInfoViewControllerTypeFriend,//查看好友信息
    WLUserInfoViewControllerTypeNone,//查看好友, 不显示显示开始聊天按钮
    WLUserInfoViewControllerTypeOther//其他
}WLUserInfoViewControllerType;

@class WLUserModel;
@interface WLUserInfoViewController : UITableViewController

@property (nonatomic, strong) WLUserModel *user;
@property (nonatomic, assign) WLUserInfoViewControllerType type;
+ (instancetype)userInfoViewController;

@end
