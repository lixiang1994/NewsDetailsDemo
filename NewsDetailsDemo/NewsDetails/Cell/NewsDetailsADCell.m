//
//  NewsDetailsADCell.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsADCell.h"

#import "SDAutoLayout.h"

@interface NewsDetailsADCell ()

@property (nonatomic , strong ) UIImageView *thumbImageView; //图片

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UILabel *summaryLabel; //描述

@property (nonatomic , strong ) UIImageView *tagImageView; //标签

@end

@implementation NewsDetailsADCell

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
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame));

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    // 标题
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.numberOfLines = 1;
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_titleLabel];
    
    // 图片
    
    _thumbImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_thumbImageView];
    
    // 标签
    
    _tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infor_tag_ad"]];
    
    [self.contentView addSubview:_tagImageView];
    
    // 描述
    
    _summaryLabel = [[UILabel alloc] init];
    
    _summaryLabel.numberOfLines = 1;
    
    _summaryLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.contentView addSubview:_summaryLabel];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 标题
    
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView , 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(20);
    
    // 图片
    
    _thumbImageView.sd_layout
    .topSpaceToView(self.titleLabel , 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .rightSpaceToView(self.contentView, 15.0f)
    .autoHeightRatio(0.5f);
    
    // 标签
    
    _tagImageView.sd_layout
    .topSpaceToView(self.thumbImageView, 15.0f)
    .leftEqualToView(self.thumbImageView)
    .widthIs(24.0f)
    .heightIs(14.0f);
    
    // 描述
    
    _summaryLabel.sd_layout
    .topSpaceToView(self.thumbImageView, 15.0f)
    .leftSpaceToView(self.tagImageView, 10.0f)
    .rightSpaceToView(self.contentView , 15.0f)
    .heightIs(14.0f);
    
    [self setupAutoHeightWithBottomView:self.tagImageView bottomMargin:15.0f];
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.contentView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
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
    
    self.tagImageView.lee_theme
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

- (void)setModel:(id)model{
    
    _model = model;
    
    
}

@end
