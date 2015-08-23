//
//  WLContactConst.h
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WLContactFriendListPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-friendList.plist", [WLUserTool currentUser].uid]]

/** contactCell 高度*/
extern const double WLContactCellHeight;
/** contactCell PhotoView宽高*/
extern const double WLContactCellPhotoViewWH;
/** contactCell nameLabel高度*/
extern const double WLContactCellNameLabelHeight;
/** contactCell nameLabel宽度*/
extern const double WLContactCellNameLabelWidth;
/** contactCell 内边距*/
extern const double WLContactCellPadding;
/** addFriendCell 高度*/
extern const double WLAddFriendCellHeight;
/** addFriendCell PhotoView宽高*/
extern const double WLAddFriendCellPhotoViewWH;
/** addFriendCell nameLabel高度*/
extern const double WLAddFriendCellNameLabelHeight;
/** addFriendCell nameLabel宽度*/
extern const double WLAddFriendCellNameLabelWidth;
/** addFriendCell uidLabel高度*/
extern const double WLAddFriendCellUidLabelHeight;
/** addFriendCell uidLabel宽度*/
extern const double WLAddFriendCellUidLabelWidth;
/** addFriendCell 内边距*/
extern const double WLAddFriendCellPadding;



/** newFriendCell 高度*/
extern const double WLNewFriendCellHeight;
/** newFriendCell PhotoView宽高*/
extern const double WLNewFriendCellPhotoViewWH;
/** newFriendCell nameLabel高度*/
extern const double WLNewFriendCellNameLabelHeight;
/** newFriendCell nameLabel宽度*/
extern const double WLNewFriendCellNameLabelWidth;
/** newFriendCell uidLabel高度*/
extern const double WLNewFriendCellUidLabelHeight;
/** newFriendCell uidLabel宽度*/
extern const double WLNewFriendCellUidLabelWidth;
/** newFriendCell 内边距*/
extern const double WLNewFriendCellPadding;
@interface WLContactConst : NSObject

@end
