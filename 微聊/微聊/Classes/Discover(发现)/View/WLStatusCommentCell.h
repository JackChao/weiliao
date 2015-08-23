//
//  WLStatusCommentCell.h
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLStatusCommentFrameModel;
@interface WLStatusCommentCell : UITableViewCell
@property (nonatomic, strong) WLStatusCommentFrameModel *commentF;

+ (instancetype)statusCommentCellWithTableView:(UITableView *)tableView;
@end
