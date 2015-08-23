//
//  WLSuggestViewController.m
//  微聊
//
//  Created by weimi on 15/7/26.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLSuggestViewController.h"

@interface WLSuggestViewController ()

@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

@implementation WLSuggestViewController


- (IBAction)backBtnCilck:(id)sender {
    
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0.01;
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBar.alpha = 1.0;
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
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
