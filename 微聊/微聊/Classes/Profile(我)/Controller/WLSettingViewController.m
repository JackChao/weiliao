//
//  WLSettingViewController.m
//  微聊
//
//  Created by weimi on 15/8/6.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLSettingViewController.h"
#import "WLLoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WLNavigationController.h"
#import "WLUserTool.h"
@interface WLSettingViewController ()<UIAlertViewDelegate>
- (IBAction)logout:(UIButton *)sender;

@end

@implementation WLSettingViewController

+ (instancetype)settingViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WLSettingViewController" bundle:nil];
    return storyboard.instantiateInitialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)logout:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定后会注销登录状态,是否确定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {//确定
        [MBProgressHUD showMessage:@"请稍后..."];
        [WLUserTool logoutCurrentUser];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUD];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [WLLoginViewController loginViewController];
        });
    }
}
@end
