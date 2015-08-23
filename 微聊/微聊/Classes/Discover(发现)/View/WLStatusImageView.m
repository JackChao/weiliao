//
//  WLStatusImageView.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusImageView.h"
#import "UIImageView+WebCache.h"
#import "WLDiscoverConst.h"
@interface WLStatusImageView()

@property (nonatomic, strong) NSArray *imageViews;

@end


@implementation WLStatusImageView

- (NSArray *)imageViews {
    if (_imageViews == nil) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [arrayM addObject:imageView];
            [self addSubview:imageView];
        }
        _imageViews = [NSArray arrayWithArray:arrayM];
    }
    return _imageViews;
}

- (void)setPics:(NSArray *)pics {
    _pics = pics;
    NSUInteger count = pics.count;
    for (NSUInteger i = 0; i < 9; i++) {
        UIImageView *imageView =  self.imageViews[i];
        if (i < count) {
            NSString *url = pics[i];
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"all_image_default"]];
        } else {
            imageView.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageViewWH = (self.bounds.size.width - 2 * WLStatusCellImagePadding) / 3.0;
    NSUInteger count = self.pics.count;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    int col = 3;
    if (count == 4) {
        col = 2;
    }
    for (NSUInteger i = 0; i < count; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageViewX = (i % col) * (imageViewWH + WLStatusCellImagePadding);
        imageViewY = (i / col) * (imageViewWH + WLStatusCellImagePadding);
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWH, imageViewWH);
    }
}

@end
