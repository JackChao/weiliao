//
//  WLStatusCommentCell.m
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusCommentCell.h"
#import "WLPhotoView.h"
#import "WLStatusImageView.h"
#import "WLDiscoverConst.h"
#import "UIColor+ZGExtension.h"
#import "WLStatusCommentModel.h"
#import "WLStatusCommentFrameModel.h"
#import "UIImageView+WebCache.h"
#import "WLUserModel.h"

@interface WLStatusCommentCell()

@property (nonatomic, weak) UIView *commentView;
@property (nonatomic, weak) WLPhotoView *photoView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UITextView *textView;

@end

@implementation WLStatusCommentCell

+ (instancetype)statusCommentCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"statusCommentCell";
    WLStatusCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLStatusCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (UIView *)commentView {
    if (_commentView == nil) {
        UIView *commentView = [[UIView alloc] init];
        commentView.backgroundColor = [UIColor whiteColor];
        _commentView = commentView;
        [self.contentView addSubview:commentView];
    }
    return _commentView;
}


- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = WLStatusCellTimeLabelFont;
        timeLabel.textColor = [UIColor detailColor];
        [self.commentView addSubview:timeLabel];
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
        [self.commentView addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

- (WLPhotoView *)photoView {
    if (_photoView == nil) {
        WLPhotoView *PhotoView = [[WLPhotoView alloc] init];
        [self.commentView addSubview:PhotoView];
        _photoView = PhotoView;
    }
    return _photoView;
}




- (void)setCommentF:(WLStatusCommentFrameModel *)commentF {
    _commentF = commentF;
    WLStatusCommentModel *comment = commentF.comment;
    WLUserModel *user = comment.from_user;
    
    self.commentView.frame = commentF.commentViewF;
    
    self.photoView.frame = commentF.photoViewF;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"male_default_head_img"]];
    
    
    self.timeLabel.frame = commentF.timeLabelF;
    self.timeLabel.text = comment.create_time;
    
    self.textView.attributedText = comment.attributedText;
    self.textView.frame = commentF.textViewF;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
