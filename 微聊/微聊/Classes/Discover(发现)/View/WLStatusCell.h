//
//  WLStatusCell.h
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLStatusFrameModel;
@interface WLStatusCell : UITableViewCell

@property (nonatomic, strong) WLStatusFrameModel *statusF;

+ (instancetype)statusCellWithTableView:(UITableView *)tableView;

@end
