//
//  WLProfileUserCell.m
//  微聊
//
//  Created by weimi on 15/7/19.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLProfileUserCell.h"
#import "WLPhotoView.h"
#import "WLUserModel.h"
#import "UIImageView+WebCache.h"

const double WLProfileUserCellHeight = 70;

@interface WLProfileUserCell()

@property (weak, nonatomic) IBOutlet WLPhotoView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
- (IBAction)erweimaClick:(id)sender;

@end

@implementation WLProfileUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)profileUserCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"userCell";
    WLProfileUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WLProfileUserCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(WLUserModel *)model {
    _model = model;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"default_portrait_160"]];
    self.nameLabel.text = model.name;
    self.detailLabel.text = [NSString stringWithFormat:@"微聊账号:%@", model.uid];
}

- (IBAction)erweimaClick:(id)sender {
}
@end
