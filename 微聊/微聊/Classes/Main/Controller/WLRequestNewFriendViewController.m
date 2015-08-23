//
//  WLRequestNewFriendViewController.m
//  微聊
//
//  Created by weimi on 15/8/19.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLRequestNewFriendViewController.h"
#import "WLBaseTextField.h"
#import "WLUserTool.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "WLUserModel.h"
@interface WLRequestNewFriendViewController ()

@property (nonatomic, weak) WLBaseTextField *textView;

@end

@implementation WLRequestNewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    WLBaseTextField *textView = [[WLBaseTextField alloc] init];
    WLUserModel *user = [WLUserTool currentUser];
    textView.placeholder = [NSString stringWithFormat:@"你好, 我是%@!", user.name];
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    self.textView = textView;
    [textView becomeFirstResponder];
    textView.returnKeyType = UIReturnKeyDefault;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendRequest)];
    
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)goback {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendRequest {
    NSString *text = self.textView.text;
    if (!text || text.length <= 0) {
        text = self.textView.placeholder;
    }
    [ZGVL zg_sendAddFriendMessage:text to_user:self.to_user.uid success:^(NSDictionary *response) {
        [MBProgressHUD showSuccess:@"好友请求发送成功"];
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    [self goback];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
