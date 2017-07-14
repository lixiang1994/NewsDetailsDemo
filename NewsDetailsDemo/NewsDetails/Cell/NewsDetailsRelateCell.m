//
//  NewsDetailsRelateCell.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsRelateCell.h"

#import "SDAutoLayout.h"

@interface NewsDetailsRelateCell ()

@property (nonatomic , strong ) UIImageView *thumbImageView; //图片

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UILabel *summaryLabel; //描述

@property (nonatomic , strong ) UIView *bottomLineView; //底部分隔线视图

@end

@implementation NewsDetailsRelateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame));
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    // 图片
    
    _thumbImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_thumbImageView];
    
    // 标题
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.numberOfLines = 1;
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_titleLabel];
    
    // 描述
    
    _summaryLabel = [[UILabel alloc] init];
    
    _summaryLabel.numberOfLines = 1;
    
    _summaryLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.contentView addSubview:_summaryLabel];
    
    // 底部分隔线视图
    
    _bottomLineView = [UIView new];
    
    [self.contentView addSubview:_bottomLineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 图片
    
    _thumbImageView.sd_layout
    .topSpaceToView(self.contentView , 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .widthIs(80.0f)
    .heightIs(50.0f);
    
    // 标题
    
    _titleLabel.sd_layout
    .topEqualToView(self.thumbImageView)
    .leftSpaceToView(self.thumbImageView , 10.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(20);
    
    // 描述
    
    _summaryLabel.sd_layout
    .bottomEqualToView(self.thumbImageView)
    .leftEqualToView(self.titleLabel)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(20);
    
    // 底部分隔线
    
    _bottomLineView.sd_layout
    .topSpaceToView(self.thumbImageView , 15.0f)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(1 / [[UIScreen mainScreen] scale]);
    
    [self setupAutoHeightWithBottomView:self.bottomLineView bottomMargin:0.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.contentView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.selectedBackgroundView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_F8F8F8)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_1B1B1B);
    
    self.bottomLineView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_E8E8E8)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
    
    self.titleLabel.lee_theme
    .LeeAddTextColor(THEME_DAY , HEX_222222)
    .LeeAddTextColor(THEME_NIGHT , HEX_777777);
    
    self.summaryLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_555555);
    
    self.thumbImageView.lee_theme
    .LeeAddCustomConfig(THEME_DAY , ^(UIImageView *item){
        item.alpha = 1.0f;
    })
    .LeeAddCustomConfig(THEME_NIGHT , ^(UIImageView *item){
        item.alpha = 0.7f;
    });
    
    // 演示使用
    
    self.thumbImageView.lee_theme
    .LeeAddImage(THEME_DAY, [UIImage imageWithColor:LEEColorHex(HEX_F3F3F3)])
    .LeeAddImage(THEME_NIGHT, [UIImage imageWithColor:LEEColorHex(HEX_333333)]);
    
    self.titleLabel.layer.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
    
    self.summaryLabel.layer.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
}

#pragma mark - 获取数据

- (void)setModel:(id)model{
    
    _model = model;
    
}

@end
