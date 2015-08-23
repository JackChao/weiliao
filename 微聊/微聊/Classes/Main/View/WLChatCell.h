//
//  WLChatCell.h
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLChatFrameModel;
@interface WLChatCell : UITableViewCell

@property (nonatomic, strong) WLChatFrameModel *chatF;

+ (instancetype)chatCellWithTableView:(UITableView *)tableView;

@end
