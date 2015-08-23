//
//  WLBaseCell.m
//  微聊
//
//  Created by weimi on 15/7/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLActionCell.h"
#import "WLPhotoView.h"
#import "WLCellActionModel.h"
#define WLCellNameLabelFont [UIFont systemFontOfSize:16.0]
const double WLActionCellHeight = 40;
const double WLActionCellPhotoViewWH = 20;
const double WLActionCellNameLabelHeight = 20;
const double WLActionCellNameLabelWidth = 200;
const double WLActionCellPadding = 10;
@interface WLActionCell()

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) WLPhotoView *photoView;

@end

@implementation WLActionCell

#pragma mark - 懒加载
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = WLCellNameLabelFont;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)photoView {
    if (_photoView == nil) {
        WLPhotoView *photoView = [[WLPhotoView alloc] init];
        _photoView = photoView;
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}

- (void)setModel:(WLCellActionModel *)model {
    _model = model;
    self.photoView.image = [UIImage imageNamed:model.photo];
    self.nameLabel.text = model.name;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photoView.frame = CGRectMake(WLActionCellPadding, WLActionCellPadding, WLActionCellPhotoViewWH, WLActionCellPhotoViewWH);
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.photoView.frame) + WLActionCellPadding, WLActionCellPadding, WLActionCellNameLabelWidth, WLActionCellNameLabelHeight);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

+ (instancetype)actionCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"actionCell";
    WLActionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WLActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell
    ;
    
    
}

@end
