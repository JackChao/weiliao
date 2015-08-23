//
//  WLSuggestImageView.m
//  微聊
//
//  Created by weimi on 15/7/27.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLSuggestImageView.h"

@interface WLSuggestImageView()<UIGestureRecognizerDelegate>

@end

@implementation WLSuggestImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //NSLog(@"%@", gestureRecognizer);
    self.highlighted = NO;
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //NSLog(@"%@", gestureRecognizer);
    self.highlighted = YES;
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

@end
