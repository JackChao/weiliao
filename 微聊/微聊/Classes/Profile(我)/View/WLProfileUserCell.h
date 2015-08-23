//
//  WLProfileUserCell.h
//  微聊
//
//  Created by weimi on 15/7/19.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const double WLProfileUserCellHeight;

@class WLUserModel;
@interface WLProfileUserCell : UITableViewCell

@property (nonatomic, strong) WLUserModel *model;

+ (instancetype)profileUserCellWithTableView:(UITableView *)tableView;

@end
