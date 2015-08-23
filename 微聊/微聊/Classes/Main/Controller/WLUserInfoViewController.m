//
//  WLUserInfoViewController.m
//  微聊
//
//  Created by weimi on 15/8/18.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLUserInfoViewController.h"
#import "WLUserInfoViewHeadView.h"
#import "ZGVL.h"
#import "WLUserModel.h"
#import "UIColor+ZGExtension.h"
#import "WLChatViewController.h"
#import "WLRequestNewFriendViewController.h"
#import "WLNavigationController.h"
#import "MBProgressHUD+MJ.h"
#import "WLEditUserInfoViewController.h"
#import "WLDetailUserModel.h"
#import "WLUserTool.h"
@interface WLUserInfoViewController ()<WLUserInfoViewHeadViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) WLUserInfoViewHeadView *headView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) UIButton *bottomBtn;
@property (nonatomic, assign) CGFloat headViewH;
@end

@implementation WLUserInfoViewController

- (UIButton *)bottomBtn {
    
    if (_bottomBtn == nil) {
        UIButton *bottomBtn = [[UIButton alloc] init];
        _bottomBtn = bottomBtn;
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_bottomBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
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
    if (self.type == WLUserInfoViewControllerTypeFriend) {
        
        WLChatViewController *vc = [[WLChatViewController alloc] init];
        vc.toFriend = self.user;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if(self.type == WLUserInfoViewControllerTypeOther) {
        WLRequestNewFriendViewController *vc = [[WLRequestNewFriendViewController alloc] init];
        vc.to_user = self.user;
        WLNavigationController *nav = [[WLNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        WLEditUserInfoViewController *vc = [WLEditUserInfoViewController editUserInfoViewController];
        WLNavigationController *nav = [[WLNavigationController alloc] initWithRootViewController:vc];
        WLDetailUserModel *user = [[WLDetailUserModel alloc] init];
        user.uid = self.user.uid;
        user.photo = self.user.photo;
        user.name = self.user.name;
        user.age = self.ageLabel.text.integerValue;
        user.birthday = self.birthdayLabel.text;
        user.city = self.cityLabel.text;
        user.sex = self.sexLabel.text;
        vc.user = user;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)setType:(WLUserInfoViewControllerType)type {
    _type = type;
    self.bottomBtn.hidden = NO;
    if (type == WLUserInfoViewControllerTypeFriend) {
        [self.bottomBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
    } else if(type == WLUserInfoViewControllerTypeOther) {
        [self.bottomBtn setTitle:@"加为好友" forState:UIControlStateNormal];
    } else if(type == WLUserInfoViewControllerTypeSelf){
        [self.bottomBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    } else {
        self.bottomBtn.hidden = YES;
    }
}

- (void)setUser:(WLUserModel *)user {
    _user = user;
    [ZGVL zg_getUserInfo:user.uid success:^(ZGUserInfo *userInfo) {
        self.sexLabel.text = userInfo.sex;
        self.birthdayLabel.text = userInfo.birthday;
        self.cityLabel.text = userInfo.city;
        self.ageLabel.text = [NSString stringWithFormat:@"%zd", userInfo.age];
        
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络故障"];
    }];
}

+ (instancetype)userInfoViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"WLUserInfoViewController" bundle:nil];
    return sb.instantiateInitialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WLUserInfoViewHeadView *headView = [WLUserInfoViewHeadView userInfoViewHeadView];
    self.headViewH = 250;
    self.headView = headView;
    self.headView.user = self.user;
    headView.frame = CGRectMake(0, -self.headViewH, self.tableView.bounds.size.width, self.headViewH);
    [self.tableView addSubview:headView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(self.headViewH, 0, 0, 0);
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
    self.bottomBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.headViewH - 50, self.tableView.bounds.size.width, 50);
    self.title = @"名片";
    self.headView.delegate = self;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat Y = scrollView.contentOffset.y;
    CGFloat offsetY = -self.headViewH - Y;
    if (offsetY > 0) {
        self.headView.frame = CGRectMake(0, -(offsetY + self.headViewH), self.headView.frame.size.width, self.headViewH + offsetY);
    } else {
        self.headView.frame = CGRectMake(0, -self.headViewH, self.headView.frame.size.width, self.headViewH);
    }
    self.bottomBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.headViewH - offsetY - 50, self.tableView.bounds.size.width, 50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (void)userInfoViewHeadViewPhotoViewDidDoubleClick:(WLUserInfoViewHeadView *)UserInfoViewHeadView {
    if (self.type == WLUserInfoViewControllerTypeSelf) {
        UIImagePickerController *pc = [[UIImagePickerController alloc] init];
        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pc.delegate = self;
        pc.title = @"选择一张头像";
        pc.navigationItem.title = @"选择一张头像";
        [self presentViewController:pc animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [MBProgressHUD showMessage:@"请稍后..."];
    [ZGVL zg_updateUserPhoto:image success:^(ZGUserInfo *userInfo) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"头像更改成功"];
        WLUserModel *user = [WLUserTool currentUser];
        user.photo = userInfo.photo;
        [WLUserTool saveUser:user];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络故障"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
