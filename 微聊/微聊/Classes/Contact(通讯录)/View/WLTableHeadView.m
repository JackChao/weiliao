//
//  WLTableHeadView.m
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLTableHeadView.h"
#import "UIColor+ZGExtension.h"

@interface WLTableHeadView()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation WLTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        _searchBar = searchBar;
        searchBar.barTintColor = [UIColor colorWithR:236 g:236 b:236 alpha:1.0];
        searchBar.backgroundColor = [UIColor whiteColor];
        searchBar.placeholder = @"搜索用户名/昵称";
        searchBar.delegate = self;
        [self addSubview:searchBar];
    }
    return _searchBar;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor redColor];
    CGFloat maxW = self.bounds.size.width;
    CGFloat maxH = self.bounds.size.height;
    self.searchBar.frame = CGRectMake(0, 0, maxW, maxH);
}

#pragma mark searchBar 代理方法

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([self.delegate respondsToSelector:@selector(tableHeadViewSearchButtonDidClick:text:)]) {
        [self.delegate tableHeadViewSearchButtonDidClick:self text:self.searchBar.text];
    }
    [self endEditing:YES];
}
@end
