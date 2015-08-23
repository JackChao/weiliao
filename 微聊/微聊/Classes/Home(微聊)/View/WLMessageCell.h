//
//  WLMessageCell.h
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLMessageFrameModel;
@interface WLMessageCell : UITableViewCell

@property (nonatomic, strong) WLMessageFrameModel *messageF;

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@end
