//
//  WLCellSectionBaseModel.m
//  微聊
//
//  Created by weimi on 15/7/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLCellSectionBaseModel.h"
#import "MJExtension.h"
#import "WLCellActionModel.h"
@implementation WLCellSectionBaseModel

+ (NSDictionary *)objectClassInArray {
    return @{@"models" : [WLCellActionModel class]};
}

@end
