//
//  WLStatusDetailViewController.m
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusDetailViewController.h"
#import "WLStatusCell.h"
#import "WLStatusCommentCell.h"
#import "WLStatusFrameModel.h"
#import "UIColor+ZGExtension.h"
#import "MJRefresh.h"
#import "ZGVL.h"
#import "WLStatusModel.h"
#import "WLStatusCommentModel.h"
#import "WLStatusCommentFrameModel.h"
#import "MJExtension.h"
#import "WLPostStatusCommentViewController.h"
#import "WLNavigationController.h"
@interface WLStatusDetailViewController ()

@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, weak) UIButton *bottomBtn;

@end

@implementation WLStatusDetailViewController

- (UIButton *)bottomBtn {
    
    if (_bottomBtn == nil) {
        UIButton *bottomBtn = [[UIButton alloc] init];
        _bottomBtn = bottomBtn;
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_bottomBtn setTitle:@"发表评论" forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [_bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomBtn setBackgroundColor:[UIColor whiteColor]];
        UIView *div = [[UIView alloc] init];
        div.backgroundColor = [UIColor divideColor];
        div.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
        [_bottomBtn addSubview:div];
        [self.tableView addSubview:_bottomBtn];
    }
    return _bottomBtn;
}

- (void)bottomBtnClick {
    WLPostStatusCommentViewController *vc = [[WLPostStatusCommentViewController alloc] init];
    vc.status = self.statusF.status;
    WLNavigationController *nav = [[WLNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)setStatusF:(WLStatusFrameModel *)statusF {
    _statusF = statusF;
    [self.models addObject:statusF];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
}

- (void)updateModels:(NSArray *)commentDicts {
    NSArray *comments = [WLStatusCommentModel objectArrayWithKeyValuesArray:commentDicts];
    NSMutableArray *commentFs = [NSMutableArray array];
    for (WLStatusCommentModel *comment in comments) {
        WLStatusCommentFrameModel *commentF = [[WLStatusCommentFrameModel alloc] init];
        commentF.comment = comment;
        [commentFs addObject:commentF];
    }
    [self.models removeAllObjects];
    self.statusF.status.count = comments.count;
    [self.models addObject:self.statusF];
    [self.models addObjectsFromArray:commentFs];
    [self.tableView reloadData];
}

- (void)refresh {
    [ZGVL zg_getStatusComments:self.statusF.status.s_id success:^(NSArray *comments) {
        [self updateModels:comments];
        [self.tableView.header endRefreshing];
    } failure:^(NSDictionary *reason) {
        [self.tableView.header endRefreshing];
        //NSLog(@"%@", reason[@"error"][@"message"]);
    } error:^(NSError *error) {
        [self.tableView.header endRefreshing];
        //NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat Y = scrollView.contentOffset.y;
    CGFloat offsetY = -64 - Y;

    self.bottomBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - offsetY - 50, self.tableView.bounds.size.width, 50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WLStatusCell *cell = [WLStatusCell statusCellWithTableView:tableView];
        cell.statusF = self.models[0];
        return cell;
    }
    WLStatusCommentCell *cell = [WLStatusCommentCell statusCommentCellWithTableView:tableView];
    cell.commentF = self.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WLStatusFrameModel *model = self.models[0];
        return model.height;
    }
    WLStatusCommentFrameModel *model = self.models[indexPath.row];
    return model.height;
}

@end
