//
//  WLTableHeadView.h
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLTableHeadView;
@protocol WLTableHeadViewDelegate <NSObject>

@optional

- (void)tableHeadViewSearchButtonDidClick:(WLTableHeadView *)tableHeadView text:(NSString *)text;

@end

@interface WLTableHeadView : UIView
@property (nonatomic, weak) id<WLTableHeadViewDelegate> delegate;
@end
