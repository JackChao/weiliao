//
//  WLEmotionListView.m
//  微聊
//
//  Created by weimi on 15/8/2.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEmotionListView.h"
#import "WLEmotionPageView.h"
#import "WLEmotionModel.h"


@interface WLEmotionListView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation WLEmotionListView

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        _pageControl = pageControl;
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.userInteractionEnabled = YES;
        scrollView.delegate = self;
        [self insertSubview:scrollView atIndex:0];
    }
    return _scrollView;
}

- (NSMutableArray *)pageViews {
    if (_pageViews == nil) {
        _pageViews = [NSMutableArray array];
    }
    return _pageViews;
}

- (void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    //清空所有 分页数据
    [self.pageViews removeAllObjects];
    WLEmotionModel *emotion = [emotions firstObject];
    int pageMaxCount = WLEmotionPageViewDefaultPageMaxCount;
    if (emotion.isGif) {
        pageMaxCount = WLEmotionPageViewGifPageMaxCout;
    }
    NSUInteger count = emotions.count;
    //计算分页数量
    int pageNumber = ceil(count * 1.0 / pageMaxCount);
    if (pageNumber == 0) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.numberOfPages = pageNumber;
        self.pageControl.hidden = NO;
        self.pageControl.currentPage = 0;
    }
    //创建分页
    for (int i = 0; i < pageNumber; i++) {
        WLEmotionPageView *pageView = [[WLEmotionPageView alloc] init];
        NSUInteger len = pageMaxCount;
        NSUInteger loc = i * pageMaxCount;
        if (loc + len > count) {
            len = count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.pageViews addObject:pageView];
        [self.scrollView addSubview:pageView];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat MaxW = self.bounds.size.width;
    CGFloat MaxH = self.bounds.size.height;
    //设置 pageControl
    CGFloat pageControlW = MaxW;
    CGFloat pageControlH = 30;
    CGFloat pageControlX = 0;
    CGFloat pageControlY = MaxH - pageControlH;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    
    //设置scrollView
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = MaxW;
    CGFloat scrollViewH = MaxH - pageControlH;
    self.scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    
    NSUInteger count = self.pageViews.count;
    self.scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
    CGFloat pageViewX = 0;
    CGFloat pageViewY = 0;
    CGFloat pageViewW = scrollViewW;
    CGFloat pageViewH = scrollViewH;
    for (NSUInteger i = 0; i < count; i++) {
        WLEmotionPageView *pageView = self.pageViews[i];
        pageViewX = i * pageViewW;
        pageView.frame = CGRectMake(pageViewX, pageViewY, pageViewW, pageViewH);
    }
}

#pragma mark -- UIScrollView 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageControl.hidden == NO) {
        int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
        self.pageControl.currentPage = page;
    }
    
}

@end
