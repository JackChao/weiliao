//
//  WLContactCell.h
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLContactCell : UITableViewCell

@property (nonatomic, strong) id model;

+ (instancetype)contactCellWithTableView:(UITableView *)tableView;

@end
