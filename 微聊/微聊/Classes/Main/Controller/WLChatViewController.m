//
//  WLChatViewController.m
//  微聊
//
//  Created by weimi on 15/7/29.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLChatViewController.h"
#import "WLBarButtonItem.h"
#import "WLUserModel.h"
#import "WLChatFrameModel.h"
#import "WLChatModel.h"
#import "MJExtension.h"
#import "WLChatCell.h"
#import "WLChatToolBar.h"
#import "WLEmotionModel.h"
#import "WLUserTool.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "WLUserInfoViewController.h"
#import "NSString+ZGExtension.h"

@interface WLChatViewController ()<UITableViewDataSource, UITableViewDelegate, WLChatToolBarDelegate>

@property (nonatomic, strong) NSMutableArray *chatFs;
@property (nonatomic, weak) WLChatToolBar *toolBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL canGetNewChatMessage;
@property (nonatomic, assign) BOOL needGetNewChatMessage;
@end

@implementation WLChatViewController

#pragma mark -- 懒加载

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kToolBarH) style:UITableViewStylePlain];
        _tableView = tableView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 15, 0);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)chatFs {
    if (_chatFs == nil) {
        _chatFs = [NSMutableArray array];
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"Chats" ofType:@"plist"];
    }
    return _chatFs;
}
/** 设置toolBar*/
- (void)setupTooBar {
    WLChatToolBar *toolBar = [WLChatToolBar chatToolBar];
    toolBar.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolBarFrameDidChange:) name:WLChatToolBarFrameDidChangeNotification object:self.toolBar];
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
}

/** toolBar Frame 发生改变*/
- (void)toolBarFrameDidChange:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[WLChatToolBarFrameDidChangeNotificationKey] CGRectValue];
    CGFloat y = -(self.tableView.bounds.size.height - rect.origin.y);
    if (self.chatFs.count >= 4) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(0, y, self.tableView.bounds.size.width, self.view.bounds.size.height - kToolBarH);
        }];
    }
    
    
}

- (void)rightBarButtonItemClick {
    WLUserInfoViewController *vc = [WLUserInfoViewController userInfoViewController];
    vc.user = self.toFriend;
    vc.type = WLUserInfoViewControllerTypeNone;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navigation 右上角按钮
    self.navigationItem.rightBarButtonItem = [WLBarButtonItem rightBarButtonItemWithImage:@"all_top_icon_friend" highlightImage:@"all_top_icon_friend_pressed" addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    //设置标题
    self.title = self.toFriend.name;
    //去掉tableView的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //这是toolBar
    [self setupTooBar];
    
    //添加单击 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.tableView addGestureRecognizer:tap];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getNewChatMessage:0];
    [self scrollToFooter:NO];
    self.canGetNewChatMessage = YES;
    [self registerNotification];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOldMessage)];
    
}



- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewChatMessage:) name:ZGVLReceivedNewChatMessageNotification object:nil];
}

- (void)receivedNewChatMessage:(NSNotification *)notification {
    if (self.canGetNewChatMessage) {
        
        [self getNewChatMessage:-1];
        self.needGetNewChatMessage = NO;
    } else {
        self.needGetNewChatMessage = YES;
    }
}

- (NSArray *)chatFswithChatsDicts:(NSArray *)chatDicts {
    NSMutableArray *chats = [WLChatModel objectArrayWithKeyValuesArray:chatDicts];//m_id 小在前
    NSMutableArray *chatFs = [NSMutableArray array];
    for (WLChatModel *chat in chats) {
        WLChatFrameModel *chatF = [[WLChatFrameModel alloc] init];
        chatF.chat = chat;
        [chatFs addObject:chatF];
    }
    return chatFs;
}

- (void)getOldMessage {
    WLChatFrameModel *chatF = self.chatFs.firstObject;
    NSArray *chatsDictArray = [ZGVL zg_oldChatMessages:chatF.chat.m_id to_user:self.toFriend.uid];
    NSArray *chatFs = [self chatFswithChatsDicts:chatsDictArray];
    [self.tableView.header endRefreshing];
    if (chatFs.count) {
        [self.chatFs insertObjects:chatFs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, chatFs.count)]];
        [self.tableView reloadData];
    }
}

- (void)getNewChatMessage:(NSUInteger)since_id {
    if (since_id == -1) {
        WLChatFrameModel *chatF = [self.chatFs lastObject];
        since_id = chatF.chat.m_id;
    }
    NSArray *chatsDictArray = [ZGVL zg_newChatMessages:since_id to_user:self.toFriend.uid];
    NSArray *chatFs = [self chatFswithChatsDicts:chatsDictArray];
    if (chatFs.count) {
        [self.chatFs addObjectsFromArray:chatFs];
        [self.tableView reloadData];
        [self scrollToFooter:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.chatFs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLChatFrameModel *chatF = self.chatFs[indexPath.row];
    chatF.hideTime = NO;
    if (indexPath.row != 0) {
        WLChatFrameModel *chatFPre = self.chatFs[indexPath.row - 1];
        if ([[chatF.chat.time timeStringWithcurrentTime] isEqualToString:[chatFPre.chat.time timeStringWithcurrentTime]]) {
            chatF.hideTime = YES;
        }
    }
    WLChatCell *cell = [WLChatCell chatCellWithTableView:tableView];
    cell.chatF = chatF;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLChatFrameModel *chatF = self.chatFs[indexPath.row];
    return chatF.height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark -- WLChatToolBar代理方法

- (void)chatToolBarDidSendEmotion:(WLEmotionModel *)emotion {
    WLChatModel *chat = [[WLChatModel alloc] init];
    chat.text = emotion.zh_Hans;
    chat.user = [WLUserTool currentUser];
    chat.time = @"刚刚";
    chat.isMeSend = YES;
    chat.type = WLChatModelTypeGifEmotion;
    WLChatFrameModel *chatF = [[WLChatFrameModel alloc] init];
    chatF.chat = chat;
    [self insertMessage:chat];
}

- (void)chatToolBarDidSendMessge:(NSString *)text {
    WLChatModel *chat = [[WLChatModel alloc] init];
    chat.text = text;
    chat.user = [WLUserTool currentUser];
    chat.time = @"刚刚";
    chat.isMeSend = YES;
    chat.type = WLChatModelTypeText;
    [self insertMessage:chat];
}

- (void)insertMessage:(WLChatModel *)chat {
    chat.m_id = (NSUInteger)MAXFLOAT;
    ZGChatMessage *chatMessage = [[ZGChatMessage alloc] init];
    chatMessage.text = chat.text;
    chatMessage.to_user = self.toFriend.uid;
    chatMessage.type = (ZGChatMessageType)chat.type;
    self.canGetNewChatMessage = NO;
    [ZGVL zg_sendChatMessage:chatMessage success:^(NSDictionary *response) {
        chat.time = response[@"message"][@"create_time"];
        chat.m_id = [response[@"message"][@"m_id"] integerValue];
        self.canGetNewChatMessage = YES;
        if (self.needGetNewChatMessage) {
            [self getNewChatMessage:-1];
            self.needGetNewChatMessage = NO;
        }
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络故障"];
    }];
    
    WLChatFrameModel *chatF = [[WLChatFrameModel alloc] init];
    chatF.chat = chat;
    [self.chatFs addObject:chatF];
    NSIndexPath *indexPatn = [NSIndexPath indexPathForRow:self.chatFs.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPatn] withRowAnimation:UITableViewRowAnimationNone];
    [self scrollToFooter:YES];
}

/** tableView 滚动到最底部*/
- (void)scrollToFooter:(BOOL) animated{
    if (self.chatFs.count) {
        NSIndexPath *indexPatn = [NSIndexPath indexPathForRow:self.chatFs.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPatn atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
@end
