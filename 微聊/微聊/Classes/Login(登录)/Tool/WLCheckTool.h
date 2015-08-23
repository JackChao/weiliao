//
//  WLCheckTool.h
//  微聊
//
//  Created by weimi on 15/8/6.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
/** TextField text 最大长度*/
extern const int WLCheckToolTextFieldMaxLength;


@interface WLCheckTool : NSObject

+ (NSString *)loginCheck:(NSString *)username pwd:(NSString *)pwd;

+ (NSString *)registerCheck:(NSString *)username pwd1:(NSString *)pwd1 pwd2:(NSString *)pwd2;


@end
