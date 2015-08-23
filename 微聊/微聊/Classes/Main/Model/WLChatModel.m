//
//  WLChatModel.m
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatModel.h"
#import "NSString+ZGExtension.h"
#import "WLChatCellConst.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>
#import "WLUserModel.h"
#import "WLUserTool.h"

@interface WLChatModel()

@property (nonatomic, strong) NSAttributedString *attributedText;

@end

@implementation WLChatModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"user" : @"from_user", @"time" : @"create_time"};
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    _attributedText = nil;
}

- (void)setUser:(WLUserModel *)user {
    _user = user;
    if ([user.uid isEqualToString:[WLUserTool currentUser].uid]) {
        self.isMeSend = YES;
    } else {
        self.isMeSend = NO;
    }
}


- (NSAttributedString *)attributedText {
    if (_attributedText == nil) {
        _attributedText = [self.text attributedStringWithFont:WLChatCellContentViewFont];
    }
    return _attributedText;
}

@end
