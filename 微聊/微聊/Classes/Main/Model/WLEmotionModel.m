//
//  WLEmotionDefaultModel.m
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionModel.h"
#import "MJExtension.h"
@implementation WLEmotionModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"zh_Hans" : @"zh-Hans"};
}

- (void)setImage:(NSString *)image {
    _image = image;
    if ([image hasSuffix:@".gif"]) {
        self.isGif = YES;
    } else {
        self.isGif = NO;
    }
}

@end
