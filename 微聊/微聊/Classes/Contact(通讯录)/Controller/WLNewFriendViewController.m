//
//  WLNewFriendViewController.m
//  微聊
//
//  Created by weimi on 15/8/19.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLNewFriendViewController.h"
#import "WLNewFriendCellModel.h"
#import "MJRefresh.h"
#import "ZGVL.h"
#import "MJExtension.h"
#import "WLNewFriendCell.h"
#import "WLContactConst.h"
#import "WLUserModel.h"
#import "WLUserInfoViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WLBarButtonItem.h"
#import "WLAddFriendViewController.h"
@interface WLNewFriendViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) WLNewFriendCellModel *currentFriend;
@end

@implementation WLNewFriendViewController

- (NSMutableArray *)friends {
    if (_friends == nil) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.tableView.header beginRefreshing];
    self.navigationItem.rightBarButtonItem = [WLBarButtonItem rightBarButtonItemWithImage:@"all_top_icon_add_friend" highlightImage:@"all_top_icon_add_friend_pressed" addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"新的好友";
}
#pragma mark -按钮点击事件
/**
 *  添加好友
 */
- (void)addFriendAction {
    WLAddFriendViewController *vc = [[WLAddFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refresh {
    [ZGVL zg_getNewFriendRequests:^(NSArray *newFriends) {
        NSArray *friends = [WLNewFriendCellModel objectArrayWithKeyValuesArray:newFriends];
        [self.friends removeAllObjects];
        [self.friends addObjectsFromArray:friends];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSDictionary *reason) {
        NSLog(@"%@", reason[@"error"][@"message"]);
        [self.tableView.header endRefreshing];
    } error:^(NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD showError:@"网络故障"];
        [self.tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLNewFriendCellModel *model = self.friends[indexPath.row];
    WLNewFriendCell *cell = [WLNewFriendCell newFriendCellWithTableView:tableView];
    cell.model = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WLNewFriendCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentFriend = self.friends[indexPath.row];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"是否同意%@的请求", self.currentFriend.from_user.name] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"同意", @"拒绝", @"查看资料", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 3) {
        return;
    }
    if (buttonIndex == 2) {//查看资料
        WLUserInfoViewController *vc = [WLUserInfoViewController userInfoViewController];
        vc.user = self.currentFriend.from_user;
        vc.type = WLUserInfoViewControllerTypeNone;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSUInteger result = 1;
    if (buttonIndex == 0) {//同意
        result = 2;
    } else if(buttonIndex == 1) {//拒绝
        result = 1;
    }
    [ZGVL zg_dowithAddFriendRequest:self.currentFriend.f_id result:result success:^(NSDictionary *response) {
        [MBProgressHUD showSuccess:@"处理成功"];
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD showError:@"网络故障"];
    }];
}

@end
