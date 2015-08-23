//
//  WLAttributedString.h
//  微聊
//
//  Created by weimi on 15/8/4.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLHighlightText : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) BOOL isEmotion;

@end
