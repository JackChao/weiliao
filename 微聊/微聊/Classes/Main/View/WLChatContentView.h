//
//  WLChatTextView.h
//  微聊
//
//  Created by weimi on 15/7/30.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WLChatContentViewMenuOperateTypeCopy,//复制选项
    WLChatContentViewMenuOperateTypeReopst,//转发
    WLChatContentViewMenuOperateTypeDelete,//删除
    WLChatContentViewMenuOperateTypeMore,//更多
}WLChatContentViewMenuOperateType;

@class WLChatContentView, WLChatFrameModel;

@protocol WLChatContentViewDelegate <NSObject>

@optional
/**菜单项 被点击 */
- (void)chatContentView:(WLChatContentView *)chatContentView menuDidClick:(WLChatContentViewMenuOperateType)operateType;
@end

@interface WLChatContentView : UIButton

@property (nonatomic, weak) id<WLChatContentViewDelegate> delegate;

@property (nonatomic, strong) WLChatFrameModel *chatF;


@end
