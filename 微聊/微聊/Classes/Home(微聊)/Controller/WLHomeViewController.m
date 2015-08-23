//
//  WLHomeViewController.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLHomeViewController.h"
#import "WLMessageModel.h"
#import "WLMessageFrameModel.h"
#import "WLMessageCell.h"
#import "WLUserModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "NSString+ZGExtension.h"
#import "WLBarButtonItem.h"
#import "WLChatViewController.h"
#import "ZGVL.h"
#import "WLUserTool.h"
#import "MBProgressHUD+MJ.h"
#import "WLLoginViewController.h"
#import "WLNavigationController.h"
#import "WLChatModel.h"
@interface WLHomeViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *messageFrames;

@end

@implementation WLHomeViewController

#pragma mark - 懒加载
- (NSMutableArray *)messageFrames {
    if (_messageFrames == nil) {
        _messageFrames = [WLMessageFrameModel messageFrames];
    }
    return _messageFrames;
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewChatMessage:) name:ZGVLReceivedNewChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRestartLogin) name:ZGVLNeedRestartLoginNotification object:nil];
}

- (void)receivedNewChatMessage:(NSNotification *)notificaion {
    NSArray *messages = notificaion.userInfo[ZGVLReceivedNewChatMessageNotificationKey];

    NSArray *chatMessages = [WLChatModel objectArrayWithKeyValuesArray:messages];
    NSMutableArray *newMessages = [NSMutableArray array];
    
    for (WLChatModel *chat in chatMessages) {
        WLMessageModel *message = [[WLMessageModel alloc] init];
        if (chat.isMeSend) {
            message.user = chat.to_user;
            message.remindCount = 0;
        } else {
            message.user = chat.user;
            message.remindCount = 1;
        }
        
        message.detailText = chat.text;
        message.createTime = chat.time;
        message.max_m_id = chat.m_id;
        [newMessages addObject:message];
    }
    NSUInteger count = self.messageFrames.count;
    NSMutableArray *newMessageFrames = [NSMutableArray array];
    //合并消息
    for (WLMessageModel *message in newMessages) {
        NSUInteger i;
        for(i = 0; i < count; i++) {
            WLMessageFrameModel *messageFrame = self.messageFrames[i];
            //更新消息
            if ([messageFrame.message.user.uid isEqualToString:message.user.uid]) {
                [messageFrame updateWithOtherMessageModel:message];
                break;
            }
        }
        if (i == count) {
            NSUInteger j, count2 = newMessageFrames.count;
            for (j = 0; j < count2; j++) {
                WLMessageFrameModel *messageFrame = newMessageFrames[j];
                //更新消息
                if ([messageFrame.message.user.uid isEqualToString:message.user.uid]) {
                    [messageFrame updateWithOtherMessageModel:message];
                    break;
                }
            }
            if (j == count2) {
                WLMessageFrameModel *model = [[WLMessageFrameModel alloc] init];
                model.message = message;
                [newMessageFrames addObject:model];
            }
        }
    }
    if (newMessageFrames.count) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newMessageFrames.count)];
        [self.messageFrames insertObjects:newMessageFrames atIndexes:indexSet];
    }
    [self.messageFrames sortUsingComparator:^NSComparisonResult(WLMessageFrameModel *obj1, WLMessageFrameModel *obj2) {
        if (obj1.message.max_m_id > obj2.message.max_m_id) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    [self saveMessageList];
    [self.tableView reloadData];
}

- (void)saveMessageList {
    NSMutableArray *messageDicts = [NSMutableArray array];
    int len = 0;
    for (WLMessageFrameModel *mf in self.messageFrames) {
        len++;
        if (len > 25) {
            break;
        }
        WLMessageModel *message = mf.message;
        NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
        messageDict[@"remindCount"] = [NSString stringWithFormat:@"%zd", message.remindCount];
        messageDict[@"max_m_id"] = [NSString stringWithFormat:@"%zd", message.max_m_id];
        messageDict[@"detailText"] = message.detailText;
        messageDict[@"createTime"] = message.createTime;
        messageDict[@"user"] = @{
                                 @"uid" : message.user.uid,
                                 @"name" : message.user.name,
                                 @"photo" : message.user.photo,
                                 };
        [messageDicts addObject:messageDict];
    }
    [messageDicts writeToFile:WLMessageModelPath atomically:YES];
}

- (void)needRestartLogin {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"认证失效,请重新登陆" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [WLUserTool logoutCurrentUser];
    [MBProgressHUD showMessage:@"请稍后..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [UIApplication sharedApplication].keyWindow.rootViewController = [WLLoginViewController loginViewController];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置右上角 + 按钮
    self.navigationItem.rightBarButtonItem = [WLBarButtonItem rightBarButtonItemWithImage:@"all_top_icon_add" highlightImage:@"all_top_icon_add_pressed" addTarget:self action:@selector(showActionMenu) forControlEvents:UIControlEventTouchUpInside];

    //注册通知
    [self registerNotification];
    //启动ZGVL 自动获取chatmessage模块
    [ZGVL start];

}

#pragma mark - actionMenu

- (void)showActionMenu {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发起聊天",@"添加好友",@"扫一扫", nil];
    [sheet showInView:self.tableView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://发起聊天
            NSLog(@"发起聊天");
            break;
        case 1://添加好友
            NSLog(@"添加好友");
            break;
        case 2://扫一扫
            NSLog(@"扫一扫");
            break;
        default:
            break;
    }
}


//#pragma mark - 下拉刷新
//-(void)refresh {
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeNewMessages" ofType:@"plist"];
//    NSArray *newMessages = [WLMessageModel objectArrayWithFile:path];
//    NSUInteger count = self.messageFrames.count;
//    NSMutableArray *newMessageFrames = [NSMutableArray array];
//    //合并消息
//    for (WLMessageModel *message in newMessages) {
//        NSUInteger i;
//        for(i = 0; i < count; i++) {
//            WLMessageFrameModel *messageFrame = self.messageFrames[i];
//            //更新消息
//            if ([messageFrame.message.user.uid isEqualToString:message.user.uid]) {
//                [messageFrame updateWithOtherMessageModel:message];
//                break;
//            }
//        }
//        if (i == count) {
//            WLMessageFrameModel *model = [[WLMessageFrameModel alloc] init];
//            model.message = message;
//            [newMessageFrames addObject:model];
//        }
//    }
//    if (newMessageFrames.count) {
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newMessageFrames.count)];
//        [self.messageFrames insertObjects:newMessageFrames atIndexes:indexSet];
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//        [self.tableView.header endRefreshing];
//    });
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLMessageCell *cell = [WLMessageCell messageCellWithTableView:tableView];
    cell.messageF = self.messageFrames[indexPath.row];
    WLMessageFrameModel *messageF = self.messageFrames[indexPath.row];
    cell.messageF = messageF;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLMessageFrameModel *messageF = self.messageFrames[indexPath.row];
    return messageF.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WLMessageFrameModel *messageF = self.messageFrames[indexPath.row];
    messageF.message.remindCount = 0;
    [self saveMessageList];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLChatViewController *vc = [[WLChatViewController alloc] init];
    vc.toFriend = messageF.message.user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveMessageList];
}


@end
