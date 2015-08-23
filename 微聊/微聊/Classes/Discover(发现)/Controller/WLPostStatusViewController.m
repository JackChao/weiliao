//
//  WLPostStatusViewController.m
//  微聊
//
//  Created by weimi on 15/8/22.
//  Copyright (c) 2015年 weimi. All rights reserved.
//  暂时只做了发布一张图片

#import "WLPostStatusViewController.h"
#import "WLBaseTextField.h"
#import "WLPostStatusToolBar.h"
#import "WLPostStatusImageView.h"
#import "WLEmotionKeyboard.h"
#import "UIColor+ZGExtension.h"
#import "ZGVL.h"
#import "MBProgressHUD+MJ.h"
#import "WLEmotionModel.h"
@interface WLPostStatusViewController ()<WLPostStatusImageViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, WLPostStatusToolBarDelegate>

@property (nonatomic, weak) WLBaseTextField *textView;
@property (nonatomic, weak) WLPostStatusToolBar *toolBar;
@property (nonatomic, weak) WLPostStatusImageView *imageView;
@property (nonatomic, strong) WLEmotionKeyboard *emotionKeyboard;

@end

@implementation WLPostStatusViewController

- (WLEmotionKeyboard *)emotionKeyboard {
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [WLEmotionKeyboard emotionKeyboardWithKeyboardType:WLEmotionKeyboardTypeSimple];
        _emotionKeyboard.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 220);
    }
    return _emotionKeyboard;
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:WLBaseTextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionKeyboardDidSelectedEmotion:) name:WLEmotionKeyboardDidSelectedEmotionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.textView selector:@selector(deleteBackward) name:WLEmotionKeyboardDidDeleteNotification object:nil];
}

- (void)textViewTextDidChange:(NSNotification *)notification {
    NSAttributedString *text = notification.userInfo[WLBaseTextFieldTextDidChangeNotificationKey];
    if (text && text.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)emotionKeyboardDidSelectedEmotion:(NSNotification *)notification {
    WLEmotionModel *emotion = notification.userInfo[WLEmotionKeyboardDidSelectedEmotionNotificationKey];
    [self.textView insertEmotion:emotion];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发广播";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(postStatus)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    
    CGFloat screenW = self.view.bounds.size.width;
    //textView
    WLBaseTextField *textView = [[WLBaseTextField alloc] init];
    self.textView = textView;
    textView.returnKeyType = UIReturnKeyDefault;
    textView.placeholder = @"随便说点什么吧";
    textView.contentInset = UIEdgeInsetsMake(5, 0, 44, 0);
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGFloat textViewH = 250.0;
    textView.minHeight = textViewH;
    textView.maxHeight = textViewH;
    textView.background = nil;
    self.textView.frame = CGRectMake(0, 0, screenW, textViewH);
    [self.view addSubview:textView];
    
    
    //toolbar
    WLPostStatusToolBar *toolBar = [[WLPostStatusToolBar alloc] init];
    self.toolBar = toolBar;
    toolBar.delegate = self;
    CGFloat toolBarW = self.textView.frame.size.width;
    CGFloat toolBarH = 44;
    CGFloat toolBarX = 0;
    CGFloat toolBarY = self.textView.frame.size.height - toolBarH;
    toolBar.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    [self.view addSubview:toolBar];
    
    //imageView
    WLPostStatusImageView *imageView = [[WLPostStatusImageView alloc] init];
    self.imageView = imageView;
    imageView.delegate = self;
    CGFloat imageViewX = 0;
    CGFloat imageViewY = CGRectGetMaxY(self.toolBar.frame);
    CGFloat imageViewH = self.view.bounds.size.height - imageViewY;
    CGFloat imageViewW = self.view.bounds.size.width;
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithR:165.0 g:165.0 b:165.0 alpha:0.2];
    
    //注册通知
    [self registerNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.textView.fullText.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    [self.textView becomeFirstResponder];
}

- (void)goback {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postStatus {
    ZGStatus *status = [[ZGStatus alloc] init];
    status.text = self.textView.fullText;
    status.pics = self.imageView.images;
    [ZGVL zg_sendStatus:status success:^(NSDictionary *response) {
        [MBProgressHUD showSuccess:@"发布成功"];
    } failure:^(NSDictionary *reason) {
        [MBProgressHUD showError:reason[@"error"][@"message"]];
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络故障"];
    }];
    [self goback];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)postStatusImageViewAddImageBtnDidClick:(WLPostStatusImageView *)postStatusImageView {
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pc.delegate = self;
    [self presentViewController:pc animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageView addImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postStatusToolBarEmotionBtnDidClick:(WLPostStatusToolBar *)toolBar {
    WLPostStatusToolBarEmotionBtnType type = toolBar.emotionBtnType;
    if (type == WLPostStatusToolBarEmotionBtnTypeFace) {
        self.textView.inputView = self.emotionKeyboard;
        self.toolBar.emotionBtnType = WLPostStatusToolBarEmotionBtnTypeKeyboard;
    } else {
        self.textView.inputView = nil;
        self.toolBar.emotionBtnType = WLPostStatusToolBarEmotionBtnTypeFace;
    }
    [self.textView endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
