//
//  WLContactCell.h
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLNewFriendCellModel;
@interface WLNewFriendCell : UITableViewCell

@property (nonatomic, strong) WLNewFriendCellModel *model;

+ (instancetype)newFriendCellWithTableView:(UITableView *)tableView;

@end
