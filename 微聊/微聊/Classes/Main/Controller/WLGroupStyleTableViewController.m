//
//  WLGroupStyleTableViewController.m
//  微聊
//
//  Created by weimi on 15/7/19.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLGroupStyleTableViewController.h"

@interface WLGroupStyleTableViewController ()

@end

@implementation WLGroupStyleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 21;
    }
    return 19;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}


@end
