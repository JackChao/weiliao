//
//  WLContactViewController.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLContactViewController.h"
#import "WLContactCellSectionModel.h"
#import "WLContactCell.h"
#import "WLContactConst.h"
#import "UIColor+ZGExtension.h"
#import "WLContactCellFriendModel.h"
#import "WLChatViewController.h"
#import "WLBarButtonItem.h"
#import "WLAddFriendViewController.h"
#import "WLNewFriendViewController.h"
#import "WLCellActionModel.h"
#import "MJRefresh.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+ZGExtension.h"
#import "MJExtension.h"
#import "WLUserModel.h"
#import "WLUserTool.h"
@interface WLContactViewController ()
@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation WLContactViewController

#pragma mark - 懒加载
- (NSMutableArray *)sections {
    if (_sections == nil) {
        _sections = [WLContactCellSectionModel contactCellSections];
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //右侧索引颜色
    self.tableView.sectionIndexColor = [UIColor colorWithR:100 g:100 b:100 alpha:1.0];
    //添加右上角"添加好友"按钮
    
    self.navigationItem.rightBarButtonItem = [WLBarButtonItem rightBarButtonItemWithImage:@"all_top_icon_add_friend" highlightImage:@"all_top_icon_add_friend_pressed" addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];

}
//刷新好友列表
- (void)refresh {
    [ZGVL zg_getFriendList:^(NSArray *friendlist) {
        NSMutableArray *list = [NSMutableArray array];
        NSArray *users = [WLUserModel objectArrayWithKeyValuesArray:friendlist];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *titles = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"#"];
        for (NSString *title in titles) {
            dict[title] = [NSMutableArray array];
        }
        for (WLUserModel *user in users) {
            NSString *title = [NSString stringWithFormat:@"%c", [[user.name stringToPinYin] characterAtIndex:0]];
            NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
            NSMutableDictionary *friendDict = [NSMutableDictionary dictionary];
            userDict[@"uid"] = user.uid;
            userDict[@"photo"] = user.photo;
            userDict[@"name"] = user.name;
            friendDict[@"remark"] = user.name;
            friendDict[@"user"] = userDict;
            if (dict[title]) {
                [dict[title] addObject:friendDict];
            } else {
                [dict[@"#"] addObject:friendDict];
            }
        }
        for (NSString *title in titles) {
            NSMutableArray *arrayM = dict[title];
            if (arrayM.count) {
                NSMutableDictionary *friendsDict = [NSMutableDictionary dictionary];
                friendsDict[@"title"] = [title uppercaseString];
                friendsDict[@"models"] = [NSArray arrayWithArray:arrayM];
                [list addObject:friendsDict];
            }
        }
        [list writeToFile:WLContactFriendListPath atomically:YES];
        self.sections = nil;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
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

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WLContactCellSectionModel *sectionModel = self.sections[section];
    return sectionModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLContactCellSectionModel *sectionModel = self.sections[indexPath.section];
    id model = sectionModel.models[indexPath.row];
    WLContactCell *cell = [WLContactCell contactCellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WLContactCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    WLContactCellSectionModel *sectionModel = self.sections[section];
    return sectionModel.title;
}

//设置右侧导航标题
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.sections valueForKey:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLContactCellSectionModel *sectionModel = self.sections[indexPath.section];
    id model = sectionModel.models[indexPath.row];
    if ([model isKindOfClass:[WLContactCellFriendModel class]]) {//跳转到 聊天 控制器
        WLContactCellFriendModel *friendModel = (WLContactCellFriendModel *)model;
        WLChatViewController *vc = [[WLChatViewController alloc] init];
        vc.toFriend = friendModel.user;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    WLCellActionModel *action = (WLCellActionModel *)model;
    if ([@"newFriend" isEqualToString:action.popClass]) {
        WLNewFriendViewController *vc = [[WLNewFriendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -按钮点击事件
/**
 *  添加好友
 */
- (void)addFriendAction {
    WLAddFriendViewController *vc = [[WLAddFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
