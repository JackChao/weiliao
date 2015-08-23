//
//  WLAddFriendViewController.m
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLAddFriendViewController.h"
#import "UIColor+ZGExtension.h"
#import "WLTableHeadView.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "WLAddFriendCell.h"
#import "MJExtension.h"
#import "WLUserModel.h"
#import "WLContactConst.h"
#import "WLUserInfoViewController.h"

@interface WLAddFriendViewController ()<WLTableHeadViewDelegate>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation WLAddFriendViewController

- (NSMutableArray *)users {
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加新好友";
    WLTableHeadView *tableHeadView = [[WLTableHeadView alloc] init];
    tableHeadView.delegate = self;
    tableHeadView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    self.tableView.tableHeaderView = tableHeadView;
//    //给tableView 添加单击事件 结束编辑
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [self.tableView addGestureRecognizer:tap];
    //集成上拉刷新
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.tableView.footer.hidden = YES;
    
}

//- (void)tap {
//    [self.view endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLUserModel *model = self.users[indexPath.row];
    WLAddFriendCell *cell = [WLAddFriendCell addFriendCellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableHeadViewSearchButtonDidClick:(WLTableHeadView *)tableHeadView text:(NSString *)text {
    if (text.length) {
        self.tableView.hidden = NO;
        self.key = [text copy];
        self.page = 0;
        [self.users removeAllObjects];
        self.tableView.footer.hidden = NO;
        [self.tableView.footer beginRefreshing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WLAddFriendCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLUserModel *model = self.users[indexPath.row];
    WLUserInfoViewController *vc = [WLUserInfoViewController userInfoViewController];
    vc.user = model;
    vc.type = WLUserInfoViewControllerTypeOther;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 加载数据

- (void)loadMoreUsers {
    [ZGVL zg_searchUsers:self.key page:self.page success:^(NSArray *users) {
        NSArray *userModels = [WLUserModel objectArrayWithKeyValuesArray:users];
        if (userModels.count) {
            self.page += 1;
            [self.users addObjectsFromArray:userModels];
            [self.tableView reloadData];
        }
        [self.tableView.footer endRefreshing];
    } failure:^(NSDictionary *reason) {
        [self.tableView.footer endRefreshing];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [self.tableView.footer endRefreshing];
        NSLog(@"%@", error);
        [MBProgressHUD showError:@"网络故障"];
    }];
}

@end
