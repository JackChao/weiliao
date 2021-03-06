//
//  WLBaseTextField.m
//  微聊
//
//  Created by weimi on 15/7/31.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLBaseTextField.h"
#import "UIColor+ZGExtension.h"
#import "WLEmotionKeyboardNotificationConst.h"
#import "WLEmotionModel.h"
#import "WLEmotionTextAttachment.h"

@interface WLBaseTextField()

@property (nonatomic, weak) UILabel *placeholderLabel;
@property (nonatomic, weak) UIImageView *backgroundView;
@end

@implementation WLBaseTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self registNotification];
        self.placeholderColor = [UIColor colorWithR:165.0 g:165.0 b:165.0 alpha:1.0];
        self.placeholder =  @"请输入内容";
        self.background = [UIImage imageNamed:@"chat_input_bg"];
        self.font = [UIFont systemFontOfSize:15.0];
        self.textContainerInset = UIEdgeInsetsMake(self.textContainerInset.top, self.textContainerInset.left + 5, self.textContainerInset.bottom - 1 , self.textContainerInset.right + 30);
//        self.contentInset = UIEdgeInsetsMake(self.contentInset.top + 2, self.contentInset.left, self.contentInset.bottom + 2, self.contentInset.right);
        //NSLog(@"%f %f %f", self.contentOffset.y, self.textContainerInset.top, self.textContainerInset.bottom);
        self.contentOffset = CGPointMake(self.contentOffset.x, self.textContainerInset.top);
        self.maxHeight = 85.0;
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChanged];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.minHeight == 0) {
        self.minHeight = frame.size.height;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WLBaseTextFieldFrameDidChangeNotification object:self userInfo:@{WLBaseTextFieldFrameDidChangeNotificationKey : [NSValue valueWithCGRect:frame]}];
}

- (void)setBackground:(UIImage *)background {
    _background = background;
    self.backgroundView.image = background;
}

- (UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        UIImageView *backgroundView = [[UIImageView alloc] init];
        _backgroundView = backgroundView;
        [self insertSubview:backgroundView atIndex:0];
    }
    return _backgroundView;
}

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel = placeholderLabel;
        placeholderLabel.hidden = YES;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.contentMode = UIViewContentModeTopLeft;
        [self addSubview:placeholderLabel];
    }
    return _placeholderLabel;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updatePlaceholderLabel];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self updatePlaceholderLabel];
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)updatePlaceholderLabel {
    if (!self.font) {
        return;
    }
    NSDictionary *attr = @{
                           NSFontAttributeName : self.font
                           };
    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(self.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    self.placeholderLabel.frame = (CGRect){{self.textContainerInset.left + 4, self.textContainerInset.top}, size};
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = self.placeholder;
    if (!self.hasText) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    
}
/* text发生改变*/
- (void)textDidChanged {
    [self updatePlaceholderLabel];
    if (self.hasText) {
        CGFloat paddind = self.textContainerInset.left + self.textContainerInset.right + 4;
        CGSize size = [self.attributedText boundingRectWithSize:CGSizeMake(self.bounds.size.width - paddind, self.maxHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        size.height = (int)(size.height / self.font.lineHeight) * self.font.lineHeight;
        if (size.height < self.minHeight) {
            size.height = self.minHeight;
        } else if(size.height > self.maxHeight) {
            size.height = self.maxHeight;
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, size.height);
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.minHeight);
    }
    [self postTextDidChangeNotification];
}
/** 发送 text 改变通知*/
- (void)postTextDidChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:WLBaseTextFieldTextDidChangeNotification object:self userInfo:@{WLBaseTextFieldTextDidChangeNotificationKey : self.attributedText}];
}

- (void)registNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
}

/** 插入一个表情*/
- (void)insertEmotion:(WLEmotionModel *)emotion {
    //[self insertText:emotion.zh_Hans];
    NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    WLEmotionTextAttachment *emotionTextAttachment = [[WLEmotionTextAttachment alloc] init];
    emotionTextAttachment.emotion = emotion;
    emotionTextAttachment.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
    NSRange range = self.selectedRange;
    NSAttributedString *emotionString = [NSAttributedString attributedStringWithAttachment:emotionTextAttachment];
    [attributedStringM replaceCharactersInRange:range withAttributedString:emotionString];
    [attributedStringM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedStringM.length)];
    self.attributedText = attributedStringM;
    self.selectedRange = NSMakeRange(range.location + 1, 0);
    [self textDidChanged];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updatePlaceholderLabel];
    self.backgroundView.frame = self.bounds;
}
/** 返回全部文本*/
- (NSString *)fullText {
    NSAttributedString *attributedString = self.attributedText;
    NSMutableString *fullString = [NSMutableString string];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        WLEmotionTextAttachment *emotionTextAttachment = attrs[@"NSAttachment"];
        if (emotionTextAttachment) {
            [fullString appendString:emotionTextAttachment.emotion.zh_Hans];
        } else {
            NSString *str = [attributedString attributedSubstringFromRange:range].string;
            [fullString appendString:str];
        }
    }];
    return fullString;
}

//- (void)autoOffset{
//    if (self.hasText) {
//        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
//        CGFloat MaxY = 0.0;
//        for (UITextSelectionRect *rectValue in rects) {
//            CGRect rect = rectValue.rect;
//            NSLog(@"%@", NSStringFromCGRect(rect));
//            MaxY = MAX(MaxY, CGRectGetMaxY(rect));
//        }
//        //self.contentOffset = CGPointMake(0, MaxY);
//    }
//}
@end
