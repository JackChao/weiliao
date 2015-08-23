//
//  WLPostStatusImageView.h
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLPostStatusImageView;
@protocol WLPostStatusImageViewDelegate <NSObject>

@optional
- (void)postStatusImageViewAddImageBtnDidClick:(WLPostStatusImageView *)postStatusImageView;

@end

@interface WLPostStatusImageView : UIView

@property (nonatomic, weak) id<WLPostStatusImageViewDelegate> delegate;

- (NSArray *)images;
- (void)addImage:(UIImage *)image;

@end
