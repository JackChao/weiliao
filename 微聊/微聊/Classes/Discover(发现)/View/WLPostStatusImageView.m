//
//  WLPostStatusImageView.m
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLPostStatusImageView.h"

const double imageViewPadding = 10;
const double imageViewMargin = 10;

@interface WLPostStatusImageView()

@property (nonatomic, strong) NSMutableArray *imagViews;
@property (nonatomic, weak) UIButton *addImageBtn;

@end


@implementation WLPostStatusImageView

- (UIButton *)addImageBtn {
    if (_addImageBtn == nil) {
        UIButton *addImageBtn = [[UIButton alloc] init];
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@"share_icon_write_photo_add"] forState:UIControlStateNormal];
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@"share_icon_write_photo_add_pressed"] forState:UIControlStateHighlighted];
        [addImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addImageBtn = addImageBtn;
        [self addSubview:addImageBtn];
    }
    return _addImageBtn;
}

- (void)addImageBtnClick {
    if (self.imagViews.count >= 9) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(postStatusImageViewAddImageBtnDidClick:)]) {
        [self.delegate postStatusImageViewAddImageBtnDidClick:self];
    }
}

- (NSMutableArray *)imagViews {
    if (_imagViews == nil) {
        _imagViews = [NSMutableArray array];
    }
    return _imagViews;
}

- (NSArray *)images {
    NSMutableArray *images = [NSMutableArray array];
    for (UIImageView *imageView in self.imagViews) {
        [images addObject:imageView.image];
    }
    return images;
}

- (void)addImage:(UIImage *)image {
    if (self.imagViews.count >= 9) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.clipsToBounds = YES;
    imageView.image = image;
    [self.imagViews addObject:imageView];
    [self addSubview:imageView];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.imagViews.count;
    CGFloat imageViewWH = (self.bounds.size.width - 2 * (imageViewPadding + imageViewMargin)) / 3.0;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    NSUInteger i = 0;
    for (i = 0; i < count; i++) {
        NSUInteger row = i / 3;//行
        NSUInteger col = i % 3;//列
        imageViewX = col * (imageViewWH + imageViewMargin) + imageViewPadding;
        imageViewY = row * (imageViewWH + imageViewMargin) + imageViewPadding;
        UIImageView *imageView = self.imagViews[i];
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWH, imageViewWH);
    }
    if (count == 9) {
        self.addImageBtn.hidden = YES;
    } else {
        self.addImageBtn.hidden = NO;
        NSUInteger row = i / 3;//行
        NSUInteger col = i % 3;//列
        imageViewX = col * (imageViewWH + imageViewMargin) + imageViewPadding;
        imageViewY = row * (imageViewWH + imageViewMargin) + imageViewPadding;
        self.addImageBtn.frame = CGRectMake(imageViewX, imageViewY, imageViewWH, imageViewWH);
    }
}

@end
