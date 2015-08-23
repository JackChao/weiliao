//
//  WLBaseCell.h
//  微聊
//
//  Created by weimi on 15/7/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const double WLActionCellHeight;

@class WLCellActionModel;
@interface WLActionCell : UITableViewCell

@property (nonatomic, strong) WLCellActionModel *model;

+ (instancetype)actionCellWithTableView:(UITableView *)tableView;

@end
