//
//  WLContactCell.m
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLContactCell.h"
#import "WLContactCellFriendModel.h"
#import "WLCellActionModel.h"
#import "WLUserModel.h"
#import "WLPhotoView.h"
#import "UIImageView+WebCache.h"
#import "WLContactConst.h"
@interface WLContactCell()

@property (nonatomic, weak) WLPhotoView *photoView;
@property (nonatomic, weak) UILabel *nameLabel;

@end

@implementation WLContactCell

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

#pragma mark - model setter 方法
- (void)setModel:(id)model {
    _model = model;
    NSString *photo = nil;
    NSString *name = nil;
    if ([model isKindOfClass:[WLContactCellFriendModel class]]) {
        WLContactCellFriendModel *friendModel = (WLContactCellFriendModel *)model;
        photo = friendModel.user.photo;
        name = friendModel.user.name;
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"default_portrait_160"]];
    } else if ([model isKindOfClass:[WLCellActionModel class]]) {
        WLCellActionModel *actionModel = (WLCellActionModel *)model;
        photo = actionModel.photo;
        name = actionModel.name;
        [self.photoView setImage:[UIImage imageNamed:photo]];
    }
    
    self.nameLabel.text = name;
}

#pragma mark - 类实例化

+ (instancetype)contactCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"contactCell";
    WLContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photoView.frame = CGRectMake(WLContactCellPadding, WLContactCellPadding, WLContactCellPhotoViewWH, WLContactCellPhotoViewWH);
        CGFloat nameX = CGRectGetMaxX(self.photoView.frame) + WLContactCellPadding;
        self.nameLabel.frame = CGRectMake(nameX, WLContactCellPadding, WLContactCellNameLabelWidth, WLContactCellNameLabelHeight);
        self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return self;
}

@end
