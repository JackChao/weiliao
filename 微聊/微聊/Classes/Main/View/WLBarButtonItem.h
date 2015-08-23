//
//  WLBarButtonItem.h
//  微聊
//
//  Created by weimi on 15/7/17.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBarButtonItem : UIBarButtonItem

+ (instancetype)leftBarButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events;
+ (instancetype)rightBarButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events;

@end
