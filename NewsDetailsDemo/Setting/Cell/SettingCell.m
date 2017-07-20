//
//  SettingCell.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/20.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SettingCell.h"

#import "SDAutoLayout.h"

@interface SettingCell ()

@property (nonatomic , strong ) UILabel *titleLabel;

@property (nonatomic , strong ) UILabel *subTitleLabel;

@property (nonatomic , strong ) UISwitch *Switch;

@end

@implementation SettingCell

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
    
    self.selectedBackgroundView = [[UIView alloc] init];
    
    // 标题
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_titleLabel];
    
    // 副标题
    
    _subTitleLabel = [[UILabel alloc] init];
    
    _subTitleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.contentView addSubview:_subTitleLabel];
    
    // 开关
    
    _Switch = [[UISwitch alloc] init];
    
    [_Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_Switch];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 标题
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15.0f)
    .centerYEqualToView(self.contentView)
    .heightRatioToView(self.contentView, 1.0f);
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:150.0f];
    
    // 副标题
    
    self.subTitleLabel.sd_layout
    .rightSpaceToView(self.contentView, 15.0f)
    .centerYEqualToView(self.contentView)
    .heightRatioToView(self.contentView, 1.0f);
    
    [self.subTitleLabel setSingleLineAutoResizeWithMaxWidth:100.0f];
    
    // 开关
    
    self.Switch.sd_layout
    .rightSpaceToView(self.contentView, 15.0f)
    .centerYEqualToView(self.contentView)
    .heightIs(31.0f)
    .widthIs(51.0f);
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
    
    self.titleLabel.lee_theme
    .LeeAddTextColor(THEME_DAY , HEX_222222)
    .LeeAddTextColor(THEME_NIGHT , HEX_777777);
    
    self.subTitleLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_555555);
    
    self.Switch.onTintColor = LEEColorHex(@"EA1F1F");
}

#pragma mark - 获取数据

- (void)setModel:(SettingModel *)model{
    
    _model = model;
    
    self.titleLabel.text = model.title;
    
    self.subTitleLabel.text = model.subTitle;
    
    self.accessoryType = model.showAcc ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    self.Switch.hidden = !model.showSwitch;
    
    self.Switch.on = model.switchValue;

    self.selectionStyle = model.showSwitch ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}

- (void)switchAction:(UISwitch *)Switch{
    
    if (self.switchClickBlock){
        
        self.switchClickBlock(self.model.type, Switch.on);
    }
    
}

@end
