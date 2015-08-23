//
//  WLStatusModel.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusModel.h"
#import "NSString+ZGExtension.h"
#import "WLDiscoverConst.h"
#import <UIKit/UIKit.h>
@implementation WLStatusModel

- (NSString *)create_time {
    return [_create_time timeStringWithcurrentTime];
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.attributedText = [text attributedStringWithFont:WLStatusCellTextViewFont];
}

@end
