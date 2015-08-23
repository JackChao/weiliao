//
//  WLDiscoverViewController.m
//  微聊
//
//  Created by weimi on 15/7/15.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLDiscoverViewController.h"
#import "WLActionCellSectionTool.h"
#import "WLCellSectionBaseModel.h"
#import "WLCellActionModel.h"
#import "WLActionCell.h"
#import "WLStatusViewController.h"
@interface WLDiscoverViewController ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation WLDiscoverViewController

#pragma mark - 懒加载

- (NSArray *)sections {
    if (_sections == nil) {
        _sections = [WLActionCellSectionTool discoverActionCellSections];
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    WLCellActionModel *model = sectionModel.models[indexPath.row];
    WLActionCell *cell = [WLActionCell actionCellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WLCellSectionBaseModel *sectionModel = self.sections[indexPath.section];
    WLCellActionModel *actionModel = sectionModel.models[indexPath.row];
    if ([actionModel.popClass isEqualToString:@"status"]) {
        WLStatusViewController *vc = [[WLStatusViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
