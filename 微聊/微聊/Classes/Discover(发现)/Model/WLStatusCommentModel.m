//
//  WLStatusCommentModel.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusCommentModel.h"
#import "NSString+ZGExtension.h"
#import "WLDiscoverConst.h"
#import "WLUserModel.h"
#import <UIKit/UIKit.h>
@implementation WLStatusCommentModel

- (NSString *)create_time {
    return [_create_time timeStringWithcurrentTime];
}

- (NSAttributedString *)attributedText {
    if (_attributedText == nil) {
        _attributedText = [[NSString stringWithFormat:@"%@: %@", self.from_user.name, self.text] attributedStringWithFont:WLStatusCommentCellTextViewFont];
    }
    return _attributedText;
}

@end
