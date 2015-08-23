//
//  WLContactListSectionModel.m
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLContactCellSectionModel.h"
#import "WLContactCellFriendModel.h"
#import "WLCellActionModel.h"
#import "MJExtension.h"
#import "WLContactConst.h"
#import "WLUserTool.h"
#import "WLUserModel.h"
@implementation WLContactCellSectionModel

+ (NSMutableArray *)contactCellSections {
    NSString *actionPath = [[NSBundle mainBundle] pathForResource:@"ContactAction" ofType:@"plist"];
    NSString *friendPath = WLContactFriendListPath;
    NSMutableArray *sections = [NSMutableArray array];
    NSArray *actionArray = [NSArray arrayWithContentsOfFile:actionPath];
    for (NSDictionary *dict in actionArray) {
        NSArray *actions = [WLCellActionModel objectArrayWithKeyValuesArray:dict[@"models"]];
        WLContactCellSectionModel *section = [[WLContactCellSectionModel alloc] init];
        section.title = dict[@"title"];
        section.models = [NSMutableArray arrayWithArray:actions];
        [sections addObject:section];
    }
    NSArray *friendSections = [WLContactCellSectionModel objectArrayWithFile:friendPath];
    [sections addObjectsFromArray:friendSections];
    return sections;
}

+ (NSDictionary *)objectClassInArray {
    return @{@"models" : [WLContactCellFriendModel class]};
}

@end
