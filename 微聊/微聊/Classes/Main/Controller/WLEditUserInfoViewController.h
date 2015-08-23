//
//  WLEditUserInfoViewController.h
//  微聊
//
//  Created by weimi on 15/8/20.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLDetailUserModel;
@interface WLEditUserInfoViewController : UITableViewController

@property (nonatomic, strong) WLDetailUserModel *user;

+(WLEditUserInfoViewController *)editUserInfoViewController;

@end
