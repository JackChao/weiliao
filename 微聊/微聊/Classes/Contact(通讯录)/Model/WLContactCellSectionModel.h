//
//  WLContactListSectionModel.h
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLCellSectionBaseModel.h"

@interface WLContactCellSectionModel : WLCellSectionBaseModel

@property (nonatomic, copy) NSString *title;

+ (NSMutableArray *)contactCellSections;
@end
