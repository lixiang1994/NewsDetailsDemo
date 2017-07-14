//
//  NewsDetailsHeaderFooterView.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsHeaderFooterView.h"

#import "SDAutoLayout.h"

@interface NewsDetailsHeaderFooterView ()

@property (nonatomic , strong ) UILabel *titleLabel;

@end

@implementation NewsDetailsHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // 初始化数据
        
        [self initData];
        
        // 初始化视图
        
        [self initSubView];
        
        // 设置自动布局
        
        [self configAutoLayout];
        
        // 设置主题模式
        
        [self configTheme];
    }
    
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame));

    self.clipsToBounds = YES;
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    // 标题
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.numberOfLines = 1;
    
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 标题
    
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView, 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(20);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.contentView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.titleLabel.lee_theme
    .LeeAddTextColor(THEME_DAY , HEX_222222)
    .LeeAddTextColor(THEME_NIGHT , HEX_777777);
}

#pragma mark - 设置标题

- (void)configTitle:(NSString *)title{
    
    self.titleLabel.text = title;
}

@end
