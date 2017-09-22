//
//  SettingViewController.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/20.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SettingViewController.h"

#import "SDAutoLayout.h"

#import "SettingCell.h"

#import "ContentManager.h"

#import "NewsDetailsModel.h"

#import "HUD.h"

@interface SettingViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) NSMutableArray *dataArray;

@property (nonatomic , strong ) UITableView *tableView;

@end

@implementation SettingViewController

- (void)dealloc{
    
    _dataArray = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 加载全部缓存大小
    
    [self loadAllCacheSize];
}

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
    
    self.navigationBarStyleType = NavigationBarStyleTypeWhite;
    
    self.title = @"设置";
    
    __weak typeof(self) weakSelf = self;
    
    self.backBlock = ^{
        
        if (weakSelf) [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self initNavigationBar];
}

#pragma mark - 设置通知

- (void)configNotification{
    
}

#pragma mark - 初始化数据

- (void)initData{
 
    _dataArray = [NSMutableArray array];
    
    {
        NSMutableArray *array = [NSMutableArray array];
        
        {
            SettingModel *model = [[SettingModel alloc] init];
            
            model.type = SettingTypeFontSize;
            
            model.title = @"正文字号";
            
            model.subTitle = @[@"小",@"中",@"大",@"特大",@"巨大"][[ContentManager fontLevel]];
            
            model.showAcc = YES;
            
            model.showSwitch = NO;
            
            [array addObject:model];
        }
        
        {
            SettingModel *model = [[SettingModel alloc] init];
            
            model.type = SettingTypeWifi;
            
            model.title = @"省流量模式";
            
            model.subTitle = @"";
            
            model.showAcc = NO;
            
            model.showSwitch = YES;
            
            model.switchValue = [ContentManager isOnlyWifiLoad];
            
            [array addObject:model];
        }
        
        [_dataArray addObject:array];
    }
    
    {
        
        NSMutableArray *array = [NSMutableArray array];
        
        {
            SettingModel *model = [[SettingModel alloc] init];
            
            model.type = SettingTypeCache;
            
            model.title = @"清理缓存";
            
            model.subTitle = @"计算中..";
            
            model.showAcc = NO;
            
            model.showSwitch = NO;
            
            [array addObject:model];
        }
        
        [_dataArray addObject:array];
    }
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
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
    
    [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:@"CELL"];
    
    [self.view addSubview:_tableView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
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

#pragma mark - 加载全部缓存大小

- (void)loadAllCacheSize{
    
    __block NSInteger totalBytes = 0;
    
    dispatch_group_t group = dispatch_group_create();
    
    // 计算资讯详情缓存
    
    dispatch_group_enter(group);
    
    [NewsDetailsModel cacheSizeWithBlock:^(NSInteger bytes) {
        
        totalBytes += bytes;
        
        dispatch_group_leave(group);
    }];
    
    // 计算图片缓存
    
    dispatch_group_enter(group);
    
    [[YYWebImageManager sharedManager].cache.diskCache totalCostWithBlock:^(NSInteger bytes) {
        
        totalBytes += bytes;
        
        dispatch_group_leave(group);
    }];
    
    // 其他缓存计算处理....
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (!weakSelf) return ;
        
        // 计算完成 转换单位
        
        double convertedValue = totalBytes;
        
        int multiplyFactor = 0;
        
        NSArray *unitArray = @[@"B",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];
        
        while (convertedValue > 1024) {
            
            convertedValue /= 1024;
            
            multiplyFactor++;
        }
        
        NSString *cacheSize = [NSString stringWithFormat:@"%4.2f %@", convertedValue, unitArray[multiplyFactor]];
        
        SettingModel *model = [weakSelf getModelWithType:SettingTypeCache];
        
        model.subTitle = cacheSize;
        
        [weakSelf.tableView reloadData];
    });
    
}

#pragma mark - 清理全部缓存

- (void)clearAllCache{
    
    [HUD showLoading:@"清理中"];
    
    dispatch_group_t group = dispatch_group_create();
    
    // 清理资讯详情缓存
    
    dispatch_group_enter(group);
    
    [NewsDetailsModel clearAllCacheWithBlock:^{
       
        dispatch_group_leave(group);
    }];
    
    // 清理资讯详情内容缓存 (TEMP)
    
    dispatch_group_enter(group);
    
    [ContentManager clearCacheWithResultBlock:^{
       
        dispatch_group_leave(group);
    }];
    
    // 清理图片缓存
    
    dispatch_group_enter(group);
    
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjectsWithBlock:^{
      
        dispatch_group_leave(group);
    }];
    
    // 其他缓存清理处理....
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (!weakSelf) return ;
        
        // 清理完成
        
        [HUD showMessage:@"清理完成"];
        
        SettingModel *model = [weakSelf getModelWithType:SettingTypeCache];
        
        model.subTitle = @"清理完成";
        
        [weakSelf.tableView reloadData];
    });
    
}

- (SettingModel *)getModelWithType:(SettingType)type{
    
    for (NSMutableArray *array in self.dataArray) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld" , type];
        
        NSArray *result = [array filteredArrayUsingPredicate:predicate];
        
        if (result.count) {
            
            return result.firstObject;
        }
        
    }

    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    
    cell.switchClickBlock = ^(SettingType type, BOOL result) {
      
        if (!weakSelf) return ;
        
        switch (type) {
            
            case SettingTypeWifi:
                
                // 仅WIFI加载图片
                
                [ContentManager setIsOnlyWifiLoad:result];
                
                break;
                
            default:
                break;
        }
        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingModel *model = self.dataArray[indexPath.section][indexPath.row];
    
    switch (model.type) {
        
        case SettingTypeFontSize:
            
            break;
            
        case SettingTypeCache:
            
            [self clearAllCache];
            
            break;
            
        default:
            break;
    }
    
}

@end
