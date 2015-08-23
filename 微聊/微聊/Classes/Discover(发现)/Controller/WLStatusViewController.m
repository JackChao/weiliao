//
//  WLStatusViewController.m
//  微聊
//
//  Created by weimi on 15/8/21.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLStatusViewController.h"
#import "MJRefresh.h"
#import "WLStatusCell.h"
#import "WLStatusModel.h"
#import "WLStatusFrameModel.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "WLBarButtonItem.h"
#import "WLNavigationController.h"
#import "WLPostStatusViewController.h"
#import "WLStatusDetailViewController.h"
@interface WLStatusViewController ()

@property (nonatomic, strong) NSMutableArray *statusFs;

@end

@implementation WLStatusViewController

- (NSMutableArray *)statusFs {
    if (_statusFs == nil) {
        _statusFs = [NSMutableArray array];
    }
    return _statusFs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewStatus)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshOldStatus)];
    self.tableView.footer.hidden = YES;
    [self.tableView.header beginRefreshing];
    self.title = @"微广播";
    WLBarButtonItem *right = [WLBarButtonItem rightBarButtonItemWithImage:@"all_top_icon_share" highlightImage:@"all_top_icon_share_pressed" addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)rightBarButtonClick {
    WLPostStatusViewController *vc = [[WLPostStatusViewController alloc] init];
    WLNavigationController *nav = [[WLNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSArray *)statusFsWithStatusDicts:(NSArray *)statusDicts {
    NSArray *statuses = [WLStatusModel objectArrayWithKeyValuesArray:statusDicts];
    NSMutableArray *statusFs = [NSMutableArray array];
    for (WLStatusModel *status in statuses) {
        WLStatusFrameModel *statusF = [[WLStatusFrameModel alloc] init];
        statusF.status = status;
        [statusFs addObject:statusF];
    }
    return statusFs;
}

- (void)refreshOldStatus {
    NSUInteger max_id = 0;
    if (self.statusFs.count) {
        WLStatusFrameModel *statusF = self.statusFs.lastObject;
        max_id = statusF.status.s_id;
    }
    [ZGVL zg_oldStatus:max_id success:^(NSArray *statuses) {
        [self.tableView.footer endRefreshing];
        if (statuses.count) {
            NSArray *statusFs = [self statusFsWithStatusDicts:statuses];
            [self.statusFs addObjectsFromArray:statusFs];
            [self.tableView reloadData];
        }
    } failure:^(NSDictionary *reason) {
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络故障"];
    }];
}

- (void)refreshNewStatus {
    NSUInteger since_id = 0;
    if (self.statusFs.count) {
        WLStatusFrameModel *statusF = self.statusFs.firstObject;
        since_id = statusF.status.s_id;
    }
    [ZGVL zg_newStatus:since_id success:^(NSArray *statuses) {
        [self.tableView.header endRefreshing];
        if (statuses.count) {
            NSArray *statusFs = [self statusFsWithStatusDicts:statuses];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statusFs.count)];
            [self.statusFs insertObjects:statusFs atIndexes:indexSet];
            [self.tableView reloadData];
            self.tableView.footer.hidden = NO;
        }
    } failure:^(NSDictionary *reason) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:@"网络故障"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLStatusFrameModel *statusF = self.statusFs[indexPath.row];
    WLStatusCell *cell = [WLStatusCell statusCellWithTableView:tableView];
    cell.statusF = statusF;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLStatusFrameModel *statusF = self.statusFs[indexPath.row];
    return statusF.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLStatusDetailViewController *vc = [[WLStatusDetailViewController alloc] init];
    vc.statusF = self.statusFs[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
