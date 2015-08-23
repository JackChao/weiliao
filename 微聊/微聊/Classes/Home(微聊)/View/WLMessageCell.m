//
//  WLMessageCell.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLMessageCell.h"
#import "UIImageView+WebCache.h"
#import "WLMessageModel.h"
#import "WLUserModel.h"
#import "WLMessageFrameModel.h"
#import "UIColor+ZGExtension.h"
#import "WLHomeConst.h"
#import "WLPhotoView.h"
@interface WLMessageCell()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) WLPhotoView *photoView;
@property (nonatomic, weak) UILabel *createTimeLabel;
@property (nonatomic, weak) UIButton *remindView;

@end

@implementation WLMessageCell

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = WLMessageCellNameLabelFont;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        UILabel *detailLabel = [[UILabel alloc] init];
        _detailLabel = detailLabel;
        detailLabel.font = WLMessageCellDetailLabelFont;
        detailLabel.textColor = [UIColor detailColor];
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)photoView {
    if (_photoView == nil) {
        WLPhotoView *photoView = [[WLPhotoView alloc] init];
        _photoView = photoView;
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}

- (UILabel *)createTimeLabel {
    if (_createTimeLabel == nil) {
        UILabel *createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel = createTimeLabel;
        createTimeLabel.textColor = [UIColor colorWithR:140 g:140 b:140 alpha:1.0];
        createTimeLabel.font = WLMessageCellCreateTimeLabelFont;
        [self.contentView addSubview:_createTimeLabel];
    }
    return _createTimeLabel;
}

- (UIButton *)remindView {
    if (_remindView == nil) {
        UIButton *remindView = [[UIButton alloc] init];
        _remindView = remindView;
        remindView.titleLabel.font = WLMessageCellRemindViewFont;
        remindView.titleLabel.textColor = [UIColor whiteColor];
        [remindView setBackgroundImage:[UIImage imageNamed:@"all_info_remind"] forState:UIControlStateNormal];
        remindView.userInteractionEnabled = NO;
        [self.contentView addSubview:_remindView];
    }
    return _remindView;
}

/** message 模型set方法*/
- (void)setMessageF:(WLMessageFrameModel *)messageF {
    _messageF = messageF;
    WLMessageModel *message = messageF.message;
    
    //设置头像
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:message.user.photo] placeholderImage:[UIImage imageNamed:@"default_portrait_160"]];
    self.photoView.frame = messageF.photoViewF;
    
    //设置昵称
    self.nameLabel.text = message.user.name;
    self.nameLabel.frame = messageF.nameLabelF;
    
    //详细信息  最近一条对话记录
    self.detailLabel.text = message.detailText;
    self.detailLabel.frame = messageF.detailLabelF;
    
    self.createTimeLabel.text = message.timeWithCurrentTime;
    self.createTimeLabel.frame = messageF.createTimeLabelF;
    
    //设置提示小红点
    if(message.remindCount != 0) {
        //self.remindView.text = message.remindCountString;
        [self.remindView setTitle:message.remindCountString forState:UIControlStateNormal];
        self.remindView.frame = messageF.remindViewF;
        self.remindView.hidden = NO;
    } else {
        self.remindView.hidden = YES;
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"messageCell";
    WLMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[WLMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
