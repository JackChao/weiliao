//
//  WLBarButtonItem.m
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLBarButtonItem.h"

@implementation WLBarButtonItem

+ (instancetype)leftBarButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events{
    UIButton *btn = [self buttonWithImage:image highlightImage:highlightImage addTarget:target action:selector forControlEvents:events];
    CGFloat offset = btn.currentImage.size.width * 0.7;
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -offset, 0, 0)];
    WLBarButtonItem *barBtn = [[WLBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}

+ (instancetype)rightBarButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events {
    UIButton *btn = [self buttonWithImage:image highlightImage:highlightImage addTarget:target action:selector forControlEvents:events];
    CGFloat offset = btn.currentImage.size.width * 0.7;
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -offset)];
    WLBarButtonItem *barBtn = [[WLBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}

+ (UIButton *)buttonWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    [btn addTarget:target action:selector forControlEvents:events];
    return btn;
}
@end
