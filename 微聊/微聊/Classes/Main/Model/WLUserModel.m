//
//  WLUserModel.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLUserModel.h"

@implementation WLUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.photo forKey:@"photp"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.photo = [aDecoder decodeObjectForKey:@"photp"];
    }
    return self;
}

@end
