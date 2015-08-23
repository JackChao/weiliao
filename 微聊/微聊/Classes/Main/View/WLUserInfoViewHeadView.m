//
//  WLUserInfoViewHeadView.m
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLUserInfoViewHeadView.h"
#import "WLUserModel.h"
#import "WLPhotoView.h"
#import "UIImage+ZGExtension.h"
#import "UIImageView+WebCache.h"
@interface WLUserInfoViewHeadView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet WLPhotoView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) CGPoint photoViewCenter;

@end

@implementation WLUserInfoViewHeadView

+ (instancetype)userInfoViewHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WLUserInfoViewHeadView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgImageView.image = [self.bgImageView.image imgWithBlur];
    self.photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoViewClick)];
    [self.photoView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoViewDoubleClick)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.photoView addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewClick)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (void)maskViewClick {

    [UIView animateWithDuration:0.5 animations:^{
        self.photoView.bounds = CGRectMake(0, 0, 100, 100);
        self.photoView.layer.cornerRadius = 50;
        self.photoView.center = self.photoViewCenter;
    }];
    [self.maskView removeFromSuperview];
}

- (void)photoViewClick {
    self.photoViewCenter = self.photoView.center;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskView];
    CGPoint center = CGPointMake(self.photoViewCenter.x, self.bounds.size.width * 0.5 + 64);
    [UIView animateWithDuration:0.5 animations:^{
        self.photoView.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
        self.photoView.layer.cornerRadius = 0;
        self.photoView.center = center;
    }];
    
}
- (void)photoViewDoubleClick {
    if ([self.delegate respondsToSelector:@selector(userInfoViewHeadViewPhotoViewDidDoubleClick:)]) {
        [self.delegate userInfoViewHeadViewPhotoViewDidDoubleClick:self];
    }
}
- (void)setUser:(WLUserModel *)user {
    _user = user;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"male_default_head_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.bgImageView.image = [image imgWithBlur];
    }];
    self.detailLabel.text = user.uid;
    self.nameLabel.text = user.name;
}


@end
