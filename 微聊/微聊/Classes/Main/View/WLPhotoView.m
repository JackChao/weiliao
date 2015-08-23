//
//  WLUserPhotoView.m
//  微聊
//
//  Created by weimi on 15/7/16.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLPhotoView.h"

@implementation WLPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
}
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
}

@end
