//
//  WLMessageModelFrame.m
//  微聊
//
//  Created by weimi on 15/7/16.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLMessageFrameModel.h"
#import "WLUserModel.h"
#import "WLMessageModel.h"
#import "WLHomeConst.h"

const CGFloat WLMessageFrameCellPadding = 10;

@implementation WLMessageFrameModel

- (CGRect)createTimeLabelF {
    CGFloat scrrenW = [UIScreen mainScreen].bounds.size.width;
    NSDictionary *createTimeAttr = @{
                                     NSFontAttributeName : WLMessageCellDetailLabelFont
                                     };
    CGSize createTimeSize = [self.message.timeWithCurrentTime sizeWithAttributes:createTimeAttr];
    CGFloat createTimeX = scrrenW - (createTimeSize.width + WLMessageFrameCellPadding);
    CGFloat createTimeY = self.nameLabelF.origin.y;
    _createTimeLabelF = (CGRect){{createTimeX, createTimeY}, createTimeSize};
    return _createTimeLabelF;
}

/** 设置message模型 并计算frame*/
- (void)setMessage:(WLMessageModel *)message {
    _message = message;
    //CGFloat scrrenW = [UIScreen mainScreen].bounds.size.width;
    // 计算头像
    CGFloat photoViewX = WLMessageFrameCellPadding;
    CGFloat photoViewY = WLMessageFrameCellPadding;
    CGFloat photoViewWH = WLMessageCellPhotoViewWH;
    self.photoViewF = CGRectMake(photoViewX, photoViewY, photoViewWH, photoViewWH);
    
    //计算昵称标签
    CGFloat nameX = CGRectGetMaxX(self.photoViewF) + WLMessageFrameCellPadding;
    CGFloat nameY = photoViewY + 3;
    NSDictionary *nameAttr = @{
                           NSFontAttributeName : WLMessageCellNameLabelFont
                           };
    CGSize nameSize = [message.user.name sizeWithAttributes:nameAttr];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    //计算详细标签
    NSDictionary *detailAttr = @{
                            NSFontAttributeName : WLMessageCellDetailLabelFont
                            };
    CGSize detailSize = [message.detailText sizeWithAttributes:detailAttr];
    CGFloat detailX = nameX;
    CGFloat detailY = CGRectGetMaxY(self.photoViewF) - detailSize.height;
    if (detailSize.width > 200) {
        detailSize.width = 200;
    }
    self.detailLabelF = (CGRect){{detailX, detailY}, detailSize};
    
    /*//计算创建时间标签
    NSDictionary *createTimeAttr = @{
                                 NSFontAttributeName : WLMessageCellDetailLabelFont
                                 };
    CGSize createTimeSize = [message.timeWithCurrentTime sizeWithAttributes:createTimeAttr];
    CGFloat createTimeX = scrrenW - (createTimeSize.width + WLMessageFrameCellPadding);
    CGFloat createTimeY = nameY;
    self.createTimeLabelF = (CGRect){{createTimeX, createTimeY}, createTimeSize};*/
    
    //计算提示小红点
    if(message.remindCount != 0) {
//        NSDictionary *remindAttr = @{
//                                NSFontAttributeName : WLMessageCellRemindViewFont
//                                };
        CGSize remindSize = CGSizeMake(17, 17);
        CGFloat remindX = CGRectGetMaxX(self.createTimeLabelF) - (remindSize.width + WLMessageFrameCellPadding) + 3;
        CGFloat remindY = detailY;
        self.remindViewF = (CGRect){{remindX, remindY}, remindSize};
    }
    
    self.height = CGRectGetMaxY(self.photoViewF) + WLMessageFrameCellPadding;
}



+ (NSMutableArray *)messageFrames {
    NSArray *messages = [WLMessageModel messages];
    NSMutableArray *messageFrames = [NSMutableArray array];
    for (WLMessageModel *message in messages) {
        WLMessageFrameModel *model = [[WLMessageFrameModel alloc] init];
        model.message = message;
        [messageFrames addObject:model];
    }
    return messageFrames;
}

- (void)updateWithOtherMessageModel:(WLMessageModel *)other {
    if([self.message.user.uid isEqualToString:other.user.uid]) {
        self.message.remindCount += other.remindCount;
        if (other.remindCount == 0) {
            self.message.remindCount = 0;
        }
        if (self.message.max_m_id > other.max_m_id) {
            return;
        }
        self.message.max_m_id = other.max_m_id;
        self.message.detailText = other.detailText;
        self.message.createTime = other.createTime;
        self.message = self.message;//更新frame
    }
}

@end
