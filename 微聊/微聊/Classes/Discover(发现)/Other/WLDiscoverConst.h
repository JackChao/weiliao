//
//  WLDiscoverConst.h
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
//@property (nonatomic, weak) WLPhotoView *photoView;
//@property (nonatomic, weak) UILabel *nameLabel;
//@property (nonatomic, weak) UILabel *timeLabel;
//@property (nonatomic, weak) UITextView *textView;
//@property (nonatomic, weak) WLStatusImageView *statusImageView;
//@property (nonatomic, weak) UILabel *commentLabel;
#define WLStatusCellNameLabelFont [UIFont systemFontOfSize:16.0]
#define WLStatusCellTimeLabelFont [UIFont systemFontOfSize:13.0]
#define WLStatusCellTextViewFont [UIFont systemFontOfSize:15.0]
#define WLStatusCellCommentLabelFont [UIFont systemFontOfSize:14.0]
#define WLStatusCommentCellTextViewFont [UIFont systemFontOfSize:14.0]
/** StatusCell 单张图片的之间的间隔*/
extern const double WLStatusCellImagePadding;
/** StatusCell 头像的宽高*/
extern const double WLStatusCellPhotoViewWH;
extern const double WLStatusCellPadding;

@interface WLDiscoverConst : NSObject

@end
