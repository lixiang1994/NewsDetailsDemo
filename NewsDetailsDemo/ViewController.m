//
//  ViewController.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"

#import "NewsDetailsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    NewsDetailsViewController *vc = [[NewsDetailsViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
