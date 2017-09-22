//
//  ViewController.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"

#import "SDAutoLayout.h"

#import "TableViewCell.h"

#import "NewsDetailsViewController.h"

#import "SettingViewController.h"

@interface ViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) UIButton *settingButton;

@property (nonatomic , strong ) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    
    [self configNavigationBar];
    
    // 设置通知
    
    [self configNotification];
    
    // 初始化数据
    
    [self initData];
    
    // 初始化子视图
    
    [self initSubview];
    
    // 设置自动布局
    
    [self configAutoLayout];
    
    // 设置主题模式
    
    [self configTheme];
}

#pragma mark - 设置NavigationBar

- (void)configNavigationBar{
    
    self.navigationBarStyleType = NavigationBarStyleTypeRed;
    
    [self initNavigationBar];
}

#pragma mark - 设置通知

- (void)configNotification{
    
}

#pragma mark - 初始化数据

- (void)initData{

}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_settingButton setImage:[UIImage imageNamed:@"infor_nav_home_setup_nav"] forState:UIControlStateNormal];
    
    [_settingButton setImage:[UIImage imageNamed:@"infor_nav_home_setup_pre"] forState:UIControlStateHighlighted];
    
    [_settingButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationBar.contentView addSubview:_settingButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _tableView.estimatedRowHeight = 0;
    
    _tableView.estimatedSectionHeaderHeight = 0;
    
    _tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    [self.view addSubview:_tableView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    _settingButton.sd_layout
    .bottomSpaceToView(self.navigationBar.contentView , 7.0f)
    .rightSpaceToView(self.navigationBar.contentView , 7.0f)
    .widthIs(30.0f)
    .heightIs(30.0f);

    _tableView.sd_layout
    .topSpaceToView(self.navigationBar, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.tableView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525)
    .LeeAddSeparatorColor(THEME_DAY, HEX_E8E8E8)
    .LeeAddSeparatorColor(THEME_NIGHT, HEX_333333);
}

#pragma mark - 设置按钮点击事件

- (void)settingButtonAction{
    
    SettingViewController *vc = [[SettingViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    cell.model = [NSNull null];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsDetailsViewController *vc = [[NewsDetailsViewController alloc] init];
    
    vc.newsId = @"1994";
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
