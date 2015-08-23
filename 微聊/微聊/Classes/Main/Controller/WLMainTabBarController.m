//
//  WLMainTabBarController.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLMainTabBarController.h"
#import "WLNavigationController.h"
#import "WLHomeViewController.h"
#import "WLDiscoverViewController.h"
#import "WLProfileViewController.h"
#import "WLContactViewController.h"
#import "UIColor+ZGExtension.h"

@interface WLMainTabBarController ()

@end

@implementation WLMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addAllChildViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 添加所有子控制器
 */
- (void)addAllChildViewController {
    //1. 添加Home(微聊)控制器
    [self addChildViewController:@"微聊" image:@"tab_icon_chat_normal" selectedImage:@"tab_icon_chat_pressed" class:[WLHomeViewController class]];
    
    //2. 添加Contact(通讯录)控制器
    [self addChildViewController:@"通讯录" image:@"tab_icon_circle_normal" selectedImage:@"tab_icon_circle_pressed" class:[WLContactViewController class]];
    
    //3. 添加Discover(发现)控制器
    [self addChildViewController:@"发现" image:@"tab_icon_nearby_normal" selectedImage:@"tab_icon_nearby_pressed" class:[WLDiscoverViewController class]];
    
    //4. 添加Profile(我)控制器
    [self addChildViewController:@"我" image:@"tab_icon_personal_normal" selectedImage:@"tab_icon_personal_pressed" class:[WLProfileViewController class]];
    
}

/**
 添加子控制器
 */
- (void)addChildViewController:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage class:(Class)class
{
    UIViewController *vc = [[class alloc] init];
    vc.tabBarItem.title = title;
    vc.title = title;
    //241, 78, 11
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName : [UIColor colorWithR:241 g:78 b:11 alpha:1.0]
                               };
    [vc.tabBarItem setTitleTextAttributes:attr forState:UIControlStateSelected];
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    WLNavigationController *nav = [[WLNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
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
