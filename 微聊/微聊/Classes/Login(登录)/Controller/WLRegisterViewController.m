//
//  WLRegisterViewController.m
//  微聊
//
//  Created by weimi on 15/8/6.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLRegisterViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WLCheckTool.h"
#import "ZGVL.h"
@interface WLRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;

- (IBAction)registerBtnClick:(UIButton *)sender;

@end

@implementation WLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.passwordAgainField.secureTextEntry = YES;
    self.passwordField.secureTextEntry = YES;
    
    self.usernameField.delegate = self;
    self.passwordAgainField.delegate = self;
    self.passwordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnClick:(UIButton *)sender {
    NSString *username = self.usernameField.text;
    NSString *pwd1 = self.passwordField.text;
    NSString *pwd2 = self.passwordAgainField.text;
    NSString *message = [WLCheckTool registerCheck:username pwd1:pwd1 pwd2:pwd2];
    if (message) {
        [MBProgressHUD showError:message];
        return;
    }
    [MBProgressHUD showMessage:@"请稍后..."];
//    for (int i = 0; i < 100; i++) {
//        int u = 100000 + i;
//        NSString *uu = [NSString stringWithFormat:@"%d", u];
//        [NSThread sleepForTimeInterval:1.0];
//        [ZGVL zg_register:uu pwd:@"123456" success:^(NSDictionary *success) {
//            NSLog(@"%d ---- ",i);
//        } failure:^(NSDictionary *reason) {
//            NSLog(@"error-----%d", i);
//        } error:nil];
//    }
//    return;
    [ZGVL zg_register:username pwd:pwd1 success:^(NSDictionary *success) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"注册成功"];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"defaultUid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络故障"];
    }];
    
}

#pragma mark textField 代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.passwordAgainField becomeFirstResponder];
    } else {
        [self registerBtnClick:nil];
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

@end
