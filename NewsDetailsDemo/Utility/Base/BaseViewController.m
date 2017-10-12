//
//  BaseViewController.m
//  Headlines
//
//  Created by 李响 on 2017/1/10.
//  Copyright © 2017年 ck. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    // 根据导航栏样式类型 设置状态栏样式
    
    switch (self.navigationBarStyleType) {
            
        case NavigationBarStyleTypeNormal:
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
            
            break;
            
        case NavigationBarStyleTypeRed:
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
            
            break;
            
        case NavigationBarStyleTypeWhite:
            
            if ([[LEETheme currentThemeTag] isEqualToString:THEME_DAY]) {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
                
            } else if ([[LEETheme currentThemeTag] isEqualToString:THEME_NIGHT]) {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
            }
            
            break;
            
        default:
            break;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //不自动留出空白
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (_navigationBar) _navigationBar.frame = CGRectMake(0, 0, self.view.width, self.navigationBar.frame.size.height);
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    if (_navigationBar) _navigationBar.frame = CGRectMake(0, 0, self.view.width, VIEWSAFEAREAINSETS(self.view).top + 44.0f);
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    
}

#pragma mark - 初始化导航栏

- (void)initNavigationBar{
    
    _navigationBar = [[NavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [UIApplication sharedApplication].statusBarFrame.size.height + 44.0f)];
    
    _navigationBar.navigationBarStyleType = self.navigationBarStyleType;
    
    [self.view addSubview:_navigationBar];
    
    // 判断是否有标题
    
    if (self.title) {
        
        UILabel *titleLabel = [self createTitleLabel];
        
        titleLabel.text = self.title;
    }
    
    // 判断是否有返回按钮
    
    if (self.backBlock) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backButton.tag = NavigationBarSubViewTagBackButton;
        
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationBar.contentView addSubview:backButton];
        
        if (self.navigationBarStyleType == NavigationBarStyleTypeWhite) {
            
            backButton.lee_theme
            .LeeAddButtonImage(THEME_DAY, [UIImage imageNamed:@"infor_leftbackicon_nav_nor"], UIControlStateNormal)
            .LeeAddButtonImage(THEME_DAY, [UIImage imageNamed:@"infor_leftbackicon_nav_pre"], UIControlStateHighlighted)
            .LeeAddButtonImage(THEME_NIGHT, [UIImage imageNamed:@"infor_leftbackicon_white_nor"], UIControlStateNormal)
            .LeeAddButtonImage(THEME_NIGHT, [UIImage imageNamed:@"infor_leftbackicon_white_pre"], UIControlStateHighlighted);
            
        } else {
            
            [backButton setImage:[UIImage imageNamed:@"infor_leftbackicon_white_nor"] forState:UIControlStateNormal];
            
            [backButton setImage:[UIImage imageNamed:@"infor_leftbackicon_white_pre"] forState:UIControlStateHighlighted];
        }
        
        backButton.sd_layout
        .bottomEqualToView(self.navigationBar.contentView)
        .leftEqualToView(self.navigationBar.contentView)
        .widthIs(44.0f)
        .heightIs(44.0f);
    }
    
}

#pragma mark - 更新标题

- (void)updateTitle{
    
    if (self.navigationBar) {
        
        UILabel *titleLabel = [self.navigationBar viewWithTag:NavigationBarSubViewTagTitleLabel];
        
        if (!titleLabel) {
            
            titleLabel = [self createTitleLabel];
        }
        
        titleLabel.text = self.title;
    }

}

#pragma mark - 返回按钮点击事件

- (void)backButtonAction:(UIButton *)sender{
    
    if (self.backBlock) {
    
        self.backBlock();
        
    } else {
        
        if (self.navigationController) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setTitle:(NSString *)title{
    
    [super setTitle:title];
    
    [self updateTitle];
}

#pragma mark - 创建标题Label

- (UILabel *)createTitleLabel{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.tag = NavigationBarSubViewTagTitleLabel;
    
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    [self.navigationBar.contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .topEqualToView(self.navigationBar.contentView)
    .bottomEqualToView(self.navigationBar.contentView)
    .centerXEqualToView(self.navigationBar.contentView);
    
    [titleLabel setSingleLineAutoResizeWithMaxWidth:self.view.width - 60.0f];
    
    switch (self.navigationBarStyleType) {
            
        case NavigationBarStyleTypeNormal:
            
            titleLabel.textColor = [UIColor whiteColor];
            
            break;
            
        case NavigationBarStyleTypeRed:
            
            titleLabel.textColor = [UIColor whiteColor];
            
            break;
            
        case NavigationBarStyleTypeWhite:
            
            titleLabel.lee_theme
            .LeeAddTextColor(THEME_DAY, [UIColor blackColor])
            .LeeAddTextColor(THEME_NIGHT, [UIColor whiteColor]);
            
            break;
            
        default:
            break;
    }
    
    return titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清空图片内存缓存
    
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

#pragma mark - 设置竖屏

- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}

@end
