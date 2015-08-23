//
//  WLUserInfoViewHeadView.h
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLUserModel, WLUserInfoViewHeadView;

@protocol WLUserInfoViewHeadViewDelegate <NSObject>

@optional

- (void)userInfoViewHeadViewPhotoViewDidDoubleClick:(WLUserInfoViewHeadView *)UserInfoViewHeadView;

@end

@interface WLUserInfoViewHeadView : UIView

@property (nonatomic, strong) WLUserModel *user;
@property (nonatomic, weak) id<WLUserInfoViewHeadViewDelegate> delegate;

+ (instancetype)userInfoViewHeadView;

@end
