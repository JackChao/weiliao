//
//  WLStatusFrameModel.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusFrameModel.h"
#import "WLStatusModel.h"
#import "WLDiscoverConst.h"
#import "WLUserModel.h"
@implementation WLStatusFrameModel
//时间
- (CGRect)timeLabelF {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    NSDictionary *timeAttr = @{
                               NSFontAttributeName : WLStatusCellTimeLabelFont
                               };
    CGSize timeLabelSize = [self.status.create_time boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeAttr context:nil].size;
    CGFloat timeLabelX = screenW - timeLabelSize.width - WLStatusCellPadding;
    CGFloat timeLabelY = CGRectGetMidY(self.nameLabelF) - timeLabelSize.height * 0.5;
    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    return _timeLabelF;
}

- (void)setStatus:(WLStatusModel *)status {
    _status = status;
    WLUserModel *user = status.from_user;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 头像
    CGFloat photoViewX = WLStatusCellPadding;
    CGFloat photoViewY = WLStatusCellPadding;
    self.photoViewF = CGRectMake(photoViewX, photoViewY, WLStatusCellPhotoViewWH, WLStatusCellPhotoViewWH);
    // 昵称
    NSDictionary *nameAttr = @{
                               NSFontAttributeName : WLStatusCellNameLabelFont
                               };
    CGSize nameLabelSize = [user.name boundingRectWithSize:CGSizeMake(screenW - WLStatusCellPhotoViewWH - 2 * WLStatusCellPadding, WLStatusCellPhotoViewWH) options:NSStringDrawingUsesLineFragmentOrigin attributes:nameAttr context:nil].size;
    
    CGFloat nameLabelX = CGRectGetMaxX(self.photoViewF) + WLStatusCellPadding;
    CGFloat nameLabelY = CGRectGetMidY(self.photoViewF) - nameLabelSize.height * 0.5;
    self.nameLabelF = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    //内容
    CGFloat MaxW = screenW - nameLabelX - WLStatusCellPadding;
    CGSize textViewSize = [status.attributedText boundingRectWithSize:CGSizeMake(MaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat textViewX = nameLabelX;
    CGFloat textviewY = CGRectGetMaxY(self.photoViewF);
    self.textViewF = (CGRect){{textViewX, textviewY}, {MaxW, textViewSize.height}};
    
    //配图
    NSUInteger imageCount = status.pics.count;
    if (imageCount) {
        CGFloat imageViewX = nameLabelX;
        CGFloat imageViewY = CGRectGetMaxY(self.textViewF) + WLStatusCellPadding;
        CGFloat imageViewW = MaxW - 2 * WLStatusCellPadding;
        int row = ceil(imageCount / 3.0);
        CGFloat imageWH = (imageViewW - 2 * WLStatusCellImagePadding) / 3.0;
        CGFloat imageViewH = row * imageWH + (row - 1) * WLStatusCellImagePadding;
        if (imageCount == 4) {
            imageViewH = 2 * imageWH + WLStatusCellImagePadding;
        }
        self.statusImageViewF = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
    //评论数量
    //if (status.count) {
        CGFloat commentY = CGRectGetMaxY(self.textViewF) + WLStatusCellPadding;
        if (imageCount) {
            commentY = CGRectGetMaxY(self.statusImageViewF) + WLStatusCellPadding;
        }
        CGFloat commentX = textViewX;
        self.commentLabelF = CGRectMake(commentX, commentY, MaxW, 44);
    //}
    
    //高度
    
    self.height = MAX(MAX(CGRectGetMaxY(self.textViewF), CGRectGetMaxY(self.statusImageViewF)), CGRectGetMaxY(self.commentLabelF)) + 2 * WLStatusCellPadding;
    
    self.statusViewF = CGRectMake(0, 0, screenW, self.height - WLStatusCellPadding);
}

@end
