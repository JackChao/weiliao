//
//  WLProfileViewController.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLProfileViewController.h"
#import "WLActionCellSectionTool.h"
#import "WLCellSectionBaseModel.h"
#import "WLCellActionModel.h"
#import "WLActionCell.h"
#import "WLUserModel.h"
#import "MJExtension.h"
#import "WLProfileUserCell.h"
#import "WLAboutViewController.h"
#import "WLSuggestViewController.h"
#import "WLUserTool.h"
#import "WLSettingViewController.h"
#import "WLUserInfoViewController.h"
@interface WLProfileViewController ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation WLProfileViewController

#pragma mark - 懒加载

- (NSArray *)sections {
    if (_sections == nil) {
        WLUserModel *user = [WLUserTool currentUser];
        WLCellSectionBaseModel *firstSection = [[WLCellSectionBaseModel alloc] init];
        firstSection.models = [NSMutableArray arrayWithObject:user];
        NSArray *firstSectionArray = [NSArray arrayWithObject:firstSection];
        NSArray *lastSectionArray = [WLActionCellSectionTool profileActionCellSections];
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:firstSectionArray];
        [arrayM addObjectsFromArray:lastSectionArray];
        _sections = arrayM;
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    WLCellSectionBaseModel *sectionModel = self.sections.firstObject;
    [sectionModel.models removeAllObjects];
    [sectionModel.models addObject:[WLUserTool currentUser]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WLCellSectionBaseModel *sectionModel = self.sections[section];
    return sectionModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLCellSectionBaseModel *sectionModel = self.sections[indexPath.section];
    id model = sectionModel.models[indexPath.row];
    if ([model isKindOfClass:[WLCellActionModel class]]) {
        WLActionCell *cell = [WLActionCell actionCellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        WLProfileUserCell *cell = [WLProfileUserCell profileUserCellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLCellSectionBaseModel *section = self.sections[indexPath.section];
    WLCellActionModel *model = (WLCellActionModel *)section.models[indexPath.row];
    if ([model isKindOfClass:[WLUserModel class]]) {
        WLUserInfoViewController *vc = [WLUserInfoViewController userInfoViewController];
        vc.user = (WLUserModel *)model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    if ([model.popClass isEqualToString:@"about"]) {
        
        WLAboutViewController *vc = [WLAboutViewController aboutViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if([model.popClass isEqualToString:@"suggest"]){
        
        WLSuggestViewController *vc = [[WLSuggestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if([model.popClass isEqualToString:@"setting"]){
        
        WLSettingViewController *vc = [WLSettingViewController settingViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return WLProfileUserCellHeight;
    }
    return WLActionCellHeight;
}

@end
