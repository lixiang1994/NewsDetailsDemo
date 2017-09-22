//
//  NavigationBar.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/9/22.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NavigationBar.h"

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#define ONEPIXEL (1.0f/[[UIScreen mainScreen] scale])

@interface NavigationBar()

@property (nonatomic , strong ) UIView *lineView;

@end

@implementation NavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化数据
        
        [self initData];
        
        // 初始化子视图
        
        [self initSubview];
        
        // 设置自动布局
        
        [self configAutoLayout];
        
        // 设置主题
        
        [self configTheme];
    }
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.frame.size.width, 44.0f)];
    
    [self addSubview:_contentView];

    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - ONEPIXEL, self.frame.size.width, ONEPIXEL)];
    
    [self addSubview:_lineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lineView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_D7D7D7)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_444444);
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect contentFrame = self.contentView.frame;
    
    contentFrame.size.width = self.frame.size.width - VIEWSAFEAREAINSETS(self).left - VIEWSAFEAREAINSETS(self).right;
    
    self.contentView.frame = contentFrame;
    
    CGRect lineFrame = self.lineView.frame;
    
    lineFrame.origin.y = self.frame.size.height - ONEPIXEL;
    
    lineFrame.size.width = self.frame.size.width;
    
    self.lineView.frame = lineFrame;
}

- (void)safeAreaInsetsDidChange{
    
    [super safeAreaInsetsDidChange];
    
    CGRect contentFrame = self.contentView.frame;
    
    contentFrame.origin.x = VIEWSAFEAREAINSETS(self).left;
    
    contentFrame.origin.y = VIEWSAFEAREAINSETS(self).top;
    
    contentFrame.size.width = self.frame.size.width - VIEWSAFEAREAINSETS(self).left - VIEWSAFEAREAINSETS(self).right;
    
    contentFrame.size.height = 44.0f;
    
    self.contentView.frame = contentFrame;
}

- (void)setNavigationBarStyleType:(NavigationBarStyleType)navigationBarStyleType{
    
    _navigationBarStyleType = navigationBarStyleType;
    
    switch (navigationBarStyleType) {
            
        case NavigationBarStyleTypeNormal:
            
            self.backgroundColor = [UIColor clearColor];
            
            self.lineView.hidden = YES;
            
            break;
            
        case NavigationBarStyleTypeRed:
            
            self.backgroundColor = LEEColorHex(@"EA1F1F");
            
            self.lineView.hidden = YES;
            
            break;
            
        case NavigationBarStyleTypeWhite:
            
            self.lee_theme
            .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
            .LeeAddBackgroundColor(THEME_NIGHT, HEX_303030)
            .LeeAddCustomConfig(THEME_DAY, ^(id item) {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            })
            .LeeAddCustomConfig(THEME_NIGHT, ^(id item) {
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            });
            
            self.lineView.hidden = NO;
            
            break;
            
        default:
            break;
    }
}

@end
