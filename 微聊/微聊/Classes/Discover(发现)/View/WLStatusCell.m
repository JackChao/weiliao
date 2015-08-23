//
//  WLStatusCell.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusCell.h"
#import "WLPhotoView.h"
#import "WLStatusImageView.h"
#import "WLDiscoverConst.h"
#import "UIColor+ZGExtension.h"
#import "WLStatusModel.h"
#import "WLStatusFrameModel.h"
#import "UIImageView+WebCache.h"
#import "WLUserModel.h"


@interface WLStatusCell()
@property (nonatomic, weak) UIView *statusView;
@property (nonatomic, weak) WLPhotoView *photoView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) WLStatusImageView *statusImageView;
@property (nonatomic, weak) UILabel *commentLabel;

@end

@implementation WLStatusCell

+ (instancetype)statusCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"statusCell";
    WLStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)statusView {
    if (_statusView == nil) {
        UIView *statusView = [[UIView alloc] init];
        statusView.backgroundColor = [UIColor whiteColor];
        _statusView = statusView;
        [self.contentView addSubview:statusView];
    }
    return _statusView;
}


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = WLStatusCellNameLabelFont;
        nameLabel.textColor = [UIColor colorWithR:50 g:102 b:250 alpha:1.0];
        [self.statusView addSubview:nameLabel];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = WLStatusCellTimeLabelFont;
        timeLabel.textColor = [UIColor detailColor];
        [self.statusView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

- (UITextView *)textView {
    if (_textView == nil) {
        UITextView *textView = [[UITextView alloc] init];
        textView.font = WLStatusCellTextViewFont;
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.userInteractionEnabled = NO;
        [self.statusView addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

- (WLPhotoView *)photoView {
    if (_photoView == nil) {
        WLPhotoView *PhotoView = [[WLPhotoView alloc] init];
        [self.statusView addSubview:PhotoView];
        _photoView = PhotoView;
    }
    return _photoView;
}

- (WLStatusImageView *)statusImageView {
    if (_statusImageView == nil) {
        WLStatusImageView *imageView = [[WLStatusImageView alloc] init];
        _statusImageView = imageView;
        [self.statusView addSubview:imageView];
    }
    return _statusImageView;
}

- (UILabel *)commentLabel {
    if (_commentLabel == nil) {
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.font = WLStatusCellCommentLabelFont;
        commentLabel.textColor = [UIColor detailColor];
        commentLabel.textAlignment = NSTextAlignmentLeft;
        [self.statusView addSubview:commentLabel];
        _commentLabel = commentLabel;
    }
    return _commentLabel;
}

- (void)setStatusF:(WLStatusFrameModel *)statusF {
    _statusF = statusF;
    WLStatusModel *status = statusF.status;
    WLUserModel *user = status.from_user;
    
    self.statusView.frame = statusF.statusViewF;
    
    self.photoView.frame = statusF.photoViewF;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"male_default_head_img"]];
    
    self.nameLabel.frame = statusF.nameLabelF;
    self.nameLabel.text = user.name;
    
    self.timeLabel.frame = statusF.timeLabelF;
    self.timeLabel.text = status.create_time;
    
    self.textView.attributedText = status.attributedText;
    self.textView.frame = statusF.textViewF;
    
    if (status.pics.count) {
        self.statusImageView.hidden = NO;
        self.statusImageView.frame = statusF.statusImageViewF;
        self.statusImageView.pics = status.pics;
    } else {
        self.statusImageView.hidden = YES;
    }
    
    //if (status.count) {
    if (status.count) {
        self.commentLabel.text = [NSString stringWithFormat:@"%zd个评论", status.count];
    } else {
        self.commentLabel.text = [NSString stringWithFormat:@"快来抢沙发吧"];
    }
    self.commentLabel.frame = statusF.commentLabelF;
    //} else {
        //self.commentLabel.hidden = YES;
    //}
    
    
}

@end
