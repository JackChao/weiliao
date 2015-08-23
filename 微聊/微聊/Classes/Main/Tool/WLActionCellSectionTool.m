//
//  WLActionCellModelTool.m
//  微聊
//
//  Created by weimi on 15/7/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLActionCellSectionTool.h"
#import "WLCellSectionBaseModel.h"
#import "MJExtension.h"
@implementation WLActionCellSectionTool

+ (NSArray *)discoverActionCellSections {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DiscoverAction" ofType:@"plist"];
    NSArray *models = [WLCellSectionBaseModel objectArrayWithFile:path];
    return models;
}

+ (NSArray *)profileActionCellSections {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProfileAction" ofType:@"plist"];
    NSArray *models = [WLCellSectionBaseModel objectArrayWithFile:path];
    return models;
}

@end
