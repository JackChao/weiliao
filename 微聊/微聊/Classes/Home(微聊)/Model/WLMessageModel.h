//
//  WLHomeCellModel.h
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WLMessageModelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-messageList.plist", [WLUserTool currentUser].uid]]
@class WLUserModel;

@interface WLMessageModel : NSObject

@property (nonatomic, strong) WLUserModel *user;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSUInteger remindCount;
@property (nonatomic, assign) NSUInteger max_m_id;
- (NSString *)timeWithCurrentTime;
+ (NSMutableArray *)messages;
- (NSString *)remindCountString;
@end
