//
//  WLNavigationController.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLNavigationController.h"
#import "WLBarButtonItem.h"
#import "WLUserInfoViewController.h"
#import "UIColor+ZGExtension.h"
@interface WLNavigationController ()

@end

@implementation WLNavigationController

+ (void)initialize {
    UIBarButtonItem *barButton = [UIBarButtonItem appearance];
    
    NSDictionary *attrNormal = @{
                                 NSForegroundColorAttributeName : [UIColor orangeColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:17.0]
                                 };
    [barButton setTitleTextAttributes:attrNormal forState:UIControlStateNormal];
    
    NSDictionary *attrDisable = @{
                                 NSForegroundColorAttributeName : [UIColor detailColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:17.0]
                                 };
    [barButton setTitleTextAttributes:attrDisable forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(self.childViewControllers.count) {
        WLBarButtonItem *barButton = [WLBarButtonItem leftBarButtonItemWithImage:@"all_top_icon_back" highlightImage:@"all_top_icon_back_pressed" addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = barButton;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)popViewController {
    [self popViewControllerAnimated:YES];
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
