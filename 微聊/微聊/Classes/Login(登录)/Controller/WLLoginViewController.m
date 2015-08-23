//
//  WLLoginViewController.m
//  微聊
//
//  Created by weimi on 15/8/5.
//  Copyright (c) 2015年 weimi. All rights reserved.
//  这页面 代码写的太烂了, 好在 比较短  就不再纠结了.... storyboard  还是不怎熟悉啊

#import "WLLoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WLMainTabBarController.h"
#import "WLCheckTool.h"
#import "UIColor+ZGExtension.h"
#import "ZGVL.h"
#import "WLUserTool.h"
#import "WLUserModel.h"

@interface WLLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *forgotPassword;
/** passWordField  rightView */
@property (nonatomic, weak) UIButton *rightView;
- (IBAction)loginBtnClick:(UIButton *)sender;



@end

@implementation WLLoginViewController

+ (WLNavigationController *)loginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WLLoginNavigationController" bundle:nil];
    return storyboard.instantiateInitialViewController;
}

- (UIButton *)rightView {
    if (_rightView == nil) {
        UIButton *rightView = [[UIButton alloc] init];
        _rightView = rightView;
        [rightView setImage:[UIImage imageNamed:@"all_login_password_conceal"] forState:UIControlStateNormal];
        [rightView setImage:[UIImage imageNamed:@"all_login_password_show"] forState:UIControlStateSelected];
        [rightView addTarget:self action:@selector(rightViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self.passWordField addSubview:rightView];
    }
    return _rightView;
}

- (UIButton *)forgotPassword {
    if (_forgotPassword == nil) {
        
        _forgotPassword = [UIButton buttonWithType:UIButtonTypeSystem];
        [_forgotPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgotPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _forgotPassword.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_forgotPassword setTitleColor:[UIColor colorWithR:85 g:159 b:252 alpha:1.0] forState:UIControlStateNormal];
        [_forgotPassword addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPassword;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:self.forgotPassword];
        _headerView = headerView;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.title = @"登录";
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.passWordField.secureTextEntry = YES;
    
    //添加一个额外的按钮用于  截取 passwordField 的点击
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    btn.bounds = CGRectMake(0, 0, 45, 50);
    [btn addTarget:self action:@selector(rightViewClick) forControlEvents:UIControlEventTouchUpInside];
    self.passWordField.rightView = btn;
    self.passWordField.rightViewMode = UITextFieldViewModeAlways;
    
    //添加 点击事件  用于 关闭键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIt:)];
    
    [self.tableView addGestureRecognizer:tap];
    
    //设置代理
    
    self.userNameField.delegate = self;
    self.passWordField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userNameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUid"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 到此 才可以得到passwordField的真实尺寸
    CGFloat rightViewW = self.rightView.currentImage.size.width;
    CGFloat rightViewH = self.rightView.currentImage.size.height;
    CGFloat rightViewCenterX = self.passWordField.bounds.size.width - 14;
    CGFloat rightViewCenterY = self.passWordField.bounds.size.height * 0.5;
    self.rightView.bounds = (CGRect){{0, 0}, rightViewW, rightViewH};
    self.rightView.center = CGPointMake(rightViewCenterX, rightViewCenterY);
    
    self.forgotPassword.frame = CGRectMake(self.tableView.bounds.size.width - 60, 0, 60, 30);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightViewClick {
    self.passWordField.secureTextEntry = self.rightView.selected;
    self.rightView.selected = !self.rightView.selected;
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    
    NSString *username = self.userNameField.text;
    NSString *pwd = self.passWordField.text;
    NSString *message = [WLCheckTool loginCheck:username pwd:pwd];
    if (message) {
        [MBProgressHUD showError:message];
        return;
    }
    [MBProgressHUD showMessage:@"玩命登录中..."];
    [ZGVL zg_login:username pwd:pwd success:^(ZGBaseUserInfo *userinfo) {
        [MBProgressHUD hideHUD];
        WLUserModel *user = [[WLUserModel alloc] init];
        user.uid = userinfo.uid;
        user.name = userinfo.name;
        user.photo = userinfo.photo;
        [WLUserTool saveUser:user];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"defaultUid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[WLMainTabBarController alloc] init];
        
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络故障"];
    }];
}

- (void)tapIt:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -- textField 代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameField) {
        [self.passWordField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
        [self loginBtnClick:nil];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    if (text.length > WLCheckToolTextFieldMaxLength) {
        return NO;
    }
    return YES;
}

#pragma mark tableView 代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return 0;
}
@end
