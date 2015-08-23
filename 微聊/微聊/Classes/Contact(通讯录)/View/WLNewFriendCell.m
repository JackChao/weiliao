//
//  WLContactCell.m
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLNewFriendCell.h"
#import "WLUserModel.h"
#import "WLPhotoView.h"
#import "UIImageView+WebCache.h"
#import "WLContactConst.h"
#import "UIColor+ZGExtension.h"
#import "WLNewFriendCellModel.h"

@interface WLNewFriendCell()

@property (nonatomic, weak) WLPhotoView *photoView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *uidLabel;
@end

@implementation WLNewFriendCell

#pragma mark - 懒加载

- (WLPhotoView *)photoView {
    if (_photoView == nil) {
        WLPhotoView *photoView = [[WLPhotoView alloc] init];
        _photoView = photoView;
        [self.contentView addSubview:photoView];
    }
    return _photoView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
    }
    return _nameLabel;
}
- (UILabel *)uidLabel {
    if (_uidLabel == nil) {
        UILabel *uidLabel = [[UILabel alloc] init];
        _uidLabel = uidLabel;
        [self.contentView addSubview:uidLabel];
    }
    return _uidLabel;
}
#pragma mark - model setter 方法
- (void)setModel:(WLNewFriendCellModel *)model {
    _model = model;
    WLUserModel *user = model.from_user;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"default_portrait_160"]];
    self.nameLabel.text = user.name;
    self.uidLabel.text = model.text;
}

#pragma mark - 类实例化

+ (instancetype)newFriendCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"newFriendCell";
    WLNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLNewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photoView.frame = CGRectMake(WLNewFriendCellPadding, WLNewFriendCellPadding, WLNewFriendCellPhotoViewWH, WLNewFriendCellPhotoViewWH);
        CGFloat nameX = CGRectGetMaxX(self.photoView.frame) + WLNewFriendCellPadding;
        self.nameLabel.frame = CGRectMake(nameX, WLNewFriendCellPadding, WLNewFriendCellNameLabelWidth, WLNewFriendCellNameLabelHeight);
        CGFloat uidY = CGRectGetMaxY(self.nameLabel.frame);
        self.uidLabel.frame = CGRectMake(nameX, uidY, WLNewFriendCellUidLabelWidth, WLNewFriendCellUidLabelHeight);
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        self.uidLabel.font = [UIFont systemFontOfSize:13.0];
        self.uidLabel.textColor = [UIColor detailColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
