//
//  WLStatusFrameModel.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusCommentFrameModel.h"
#import "WLStatusCommentModel.h"
#import "WLDiscoverConst.h"
#import "WLUserModel.h"
@implementation WLStatusCommentFrameModel


- (void)setComment:(WLStatusCommentModel *)comment{
    _comment = comment;

    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 头像
    CGFloat photoViewX = WLStatusCellPadding;
    CGFloat photoViewY = WLStatusCellPadding;
    self.photoViewF = CGRectMake(photoViewX, photoViewY, WLStatusCellPhotoViewWH, WLStatusCellPhotoViewWH);
    
    //内容
    CGFloat textViewX = CGRectGetMaxX(self.photoViewF) + WLStatusCellPadding;
    CGFloat textviewY = photoViewY;
    CGFloat MaxW = screenW - textViewX - WLStatusCellPadding;
    CGSize textViewSize = [comment.attributedText boundingRectWithSize:CGSizeMake(MaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.textViewF = (CGRect){{textViewX, textviewY}, {MaxW, textViewSize.height}};
    
    //时间
    CGFloat timeLabelX = textViewX;
    CGFloat timeLabelY = CGRectGetMaxY(self.textViewF) + WLStatusCellPadding;
    self.timeLabelF = CGRectMake(timeLabelX, timeLabelY, MaxW, 22);
    
    self.height = MAX(CGRectGetMaxY(self.timeLabelF), CGRectGetMaxY(self.photoViewF)) + WLStatusCellPadding;
    
    self.commentViewF = CGRectMake(0, 0, screenW, self.height - 2);
}

@end
