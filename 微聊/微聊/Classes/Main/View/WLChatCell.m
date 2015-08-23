//
//  WLChatCell.m
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatCell.h"
#import "WLPhotoView.h"
#import "WLChatModel.h"
#import "WLChatFrameModel.h"
#import "NSString+ZGExtension.h"
#import "UIImageView+WebCache.h"
#import "WLUserModel.h"
#import "UIColor+ZGExtension.h"
#import "WLChatCellConst.h"
#import "WLChatContentView.h"

@interface WLChatCell()<WLChatContentViewDelegate>
/** 聊天内容*/
@property (nonatomic, weak) WLChatContentView *chatContentView;
/** 头像*/
@property (nonatomic, weak) WLPhotoView *photoView;
/** 时间*/
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation WLChatCell

#pragma mark -- 懒加载

- (WLChatContentView *)chatContentView {
    if (_chatContentView == nil) {
        WLChatContentView *chatContentView = [[WLChatContentView alloc] init];
        _chatContentView = chatContentView;
//        [_chatContentView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _chatContentView.titleLabel.numberOfLines = 0;
//        _chatContentView.titleLabel.font = WLChatCellchatContentViewFont;
//        [_chatContentView setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        _chatContentView.delegate = self;
        [self.contentView addSubview:_chatContentView];
    }
    return _chatContentView;
}

- (WLPhotoView *)photoView {
    if (_photoView == nil) {
        WLPhotoView *photoView = [[WLPhotoView alloc] init];
        _photoView = photoView;
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *timeLabel = [[UILabel alloc] init];
        _timeLabel = timeLabel;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor colorWithR:140 g:140 b:140 alpha:1.0];
        _timeLabel.font = WLChatCellTimeLabelFont;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

#pragma mark - 设置显示的内容 frame 等
- (void)setChatF:(WLChatFrameModel *)chatF {
    _chatF = chatF;
    WLChatModel *chat = chatF.chat;
    //聊天内容
    self.chatContentView.chatF = chatF;
    self.chatContentView.frame = chatF.chatContentViewF;
    //发送时间
    self.timeLabel.text = [chat.time timeStringWithcurrentTime];
    self.timeLabel.frame = chatF.timeLabelF;
    self.timeLabel.hidden = chatF.hideTime;
    
    if (!chat.isMeSend) {
        self.photoView.hidden = NO;
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:chat.user.photo] placeholderImage:[UIImage imageNamed:@"male_default_head_img"]];
        self.photoView.frame = chatF.photoViewF;
        if (chat.type == WLChatModelTypeText) {
            [self.chatContentView setBackgroundImage:[UIImage imageNamed:@"chatui_bubble_other"] forState:UIControlStateNormal];
            [self.chatContentView setBackgroundImage:[UIImage imageNamed:@"chatui_bubble_other_pressed"] forState:UIControlStateSelected];
        }
        
        
        //self.chatContentView.contentEdgeInsets = UIEdgeInsetsMake(WLChatCellchatContentViewPaddingV, WLChatCellchatContentViewPaddingH + 3, WLChatCellchatContentViewPaddingV, WLChatCellchatContentViewPaddingH - 3);
        //self.chatContentView.offsetX = 3;
        
    } else {
        self.photoView.hidden = YES;
        if (chat.type == WLChatModelTypeText) {
            [self.chatContentView setBackgroundImage:[UIImage imageNamed:@"chatui_bubble_me"] forState:UIControlStateNormal];
            [self.chatContentView setBackgroundImage:[UIImage imageNamed:@"chatui_bubble_me_pressed"] forState:UIControlStateSelected];
        }
        //self.chatContentView.contentEdgeInsets = UIEdgeInsetsMake(WLChatCellchatContentViewPaddingV, WLChatCellchatContentViewPaddingH - 3, WLChatCellchatContentViewPaddingV, WLChatCellchatContentViewPaddingH + 3);
        //self.chatContentView.offsetX = -3;
    }
}

#pragma mark -- chatContentView代理方法

- (void)chatContentView:(WLChatContentView *)chatContentView menuDidClick:(WLChatContentViewMenuOperateType)operateType {
    switch (operateType) {
        case WLChatContentViewMenuOperateTypeCopy:{
            NSLog(@"WLChatContentViewMenuOperateTypeCopy");
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = self.chatF.chat.text;
            break;
        }
            
        case WLChatContentViewMenuOperateTypeReopst:
            NSLog(@"WLChatContentViewMenuOperateTypeReopst");
            break;
        case WLChatContentViewMenuOperateTypeDelete:
            NSLog(@"WLChatContentViewMenuOperateTypeDelete");
            break;
        case WLChatContentViewMenuOperateTypeMore:
            NSLog(@"WLChatContentViewMenuOperateTypeMore");
            break;
    }
}


#pragma mark -- 重写系统方法
+ (instancetype)chatCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"chatCell";
    WLChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[WLChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
