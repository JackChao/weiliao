//
//  WLEditUserInfoViewController.m
//  微聊
//
//  Created by weimi on 15/8/20.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLEditUserInfoViewController.h"
#import "WLDetailUserModel.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "WLUserModel.h"
#import "WLUserTool.h"
@interface WLEditUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (nonatomic, strong) UIDatePicker *datePick;

@end

@implementation WLEditUserInfoViewController
- (IBAction)manBtnclick:(UIButton *)sender {
    self.womanBtn.selected = NO;
    self.manBtn.selected = YES;
}
- (IBAction)womanBtnclick:(UIButton *)sender {
    self.womanBtn.selected = YES;
    self.manBtn.selected = NO;
}

+ (WLEditUserInfoViewController *)editUserInfoViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"WLEditUserInfoViewController" bundle:nil];
    return sb.instantiateInitialViewController;
}

- (void)datePickDataChange {
    NSDate *date = self.datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.birthdayTextField.text = [formatter stringFromDate:date];
    
}

- (UIDatePicker *)datePick {
    if (_datePick == nil) {
        _datePick = [[UIDatePicker alloc] init];
        _datePick.datePickerMode = UIDatePickerModeDate;
        _datePick.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        [_datePick addTarget:self action:@selector(datePickDataChange) forControlEvents:UIControlEventValueChanged];
    }
    return _datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑资料";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendRequest)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    [self.nameTextField becomeFirstResponder];
    self.birthdayTextField.inputView = self.datePick;
    [self setup];
    
}

- (void)setup {
    self.nameTextField.text = self.user.name;
    self.ageTextField.text = [NSString stringWithFormat:@"%zd", self.user.age];
    self.cityTextField.text = self.user.city;
    self.birthdayTextField.text = self.user.birthday;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [self.datePick setDate:[formatter dateFromString:self.user.birthday] animated:NO];
    if ([self.user.sex isEqualToString:@"nv"]) {
        self.womanBtn.selected = YES;
    } else {
        self.manBtn.selected = YES;
    }
}

- (void)goback {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendRequest {
    ZGUserInfo *userInfo = [[ZGUserInfo alloc] init];
    userInfo.name = self.nameTextField.text;
    userInfo.sex = self.manBtn.selected ? @"男" : @"女";
    userInfo.birthday = self.birthdayTextField.text;
    userInfo.age = self.ageTextField.text.integerValue;
    userInfo.city = self.cityTextField.text;
    [MBProgressHUD showMessage:@"请稍后..."];
    [ZGVL zg_updateUserInfo:userInfo success:^(ZGUserInfo *userInfo) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功"];
        WLUserModel *user = [WLUserTool currentUser];
        user.name = userInfo.name;
        [WLUserTool saveUser:user];
        [self goback];
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络故障"];
    }];
}

- (void)setUser:(WLDetailUserModel *)user {
    _user = user;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

@end
