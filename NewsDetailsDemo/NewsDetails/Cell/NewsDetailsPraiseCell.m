//
//  NewsDetailsPraiseCell.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsPraiseCell.h"

#import "SDAutoLayout.h"

@interface NewsDetailsPraiseCell ()

@property (nonatomic , strong ) UIButton *praiseButton; //赞按钮

@property (nonatomic , strong ) UIButton *dislikeButton; //不喜欢按钮

@end

@implementation NewsDetailsPraiseCell

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
    
    //赞按钮
    
    _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _praiseButton.layer.shouldRasterize = YES;
    
    _praiseButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    _praiseButton.layer.drawsAsynchronously = YES;
    
    _praiseButton.layer.borderWidth = 0.5f;
    
    _praiseButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor;
    
    _praiseButton.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    [_praiseButton setTitle:@"上头条" forState:UIControlStateNormal];
    
    [_praiseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [_praiseButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_praiseButton setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    
    [_praiseButton setTitleColor:LEEColorRGB(229, 93, 93) forState:UIControlStateSelected];
    
    [_praiseButton setImage:[UIImage imageNamed:@"infor_article_good_nor"] forState:UIControlStateNormal];
    
    [_praiseButton setImage:[UIImage imageNamed:@"infor_article_good_pre"] forState:UIControlStateSelected];
    
    [_praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    
    [_praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
    
    [_praiseButton addTarget:self action:@selector(praiseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_praiseButton];
    
    
    //不喜欢按钮
    
    _dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _dislikeButton.layer.shouldRasterize = YES;
    
    _dislikeButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    _dislikeButton.layer.drawsAsynchronously = YES;
    
    _dislikeButton.layer.borderWidth = 0.5f;
    
    _dislikeButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f].CGColor;
    
    _dislikeButton.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    [_dislikeButton setTitle:@"不喜欢" forState:UIControlStateNormal];
    
    [_dislikeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [_dislikeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_dislikeButton setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.7f] forState:UIControlStateNormal];
    
    [_dislikeButton setTitleColor:LEEColorRGB(229, 93, 93) forState:UIControlStateSelected];
    
    [_dislikeButton setImage:[UIImage imageNamed:@"infor_article_dislike_nor"] forState:UIControlStateNormal];
    
    [_dislikeButton setImage:[UIImage imageNamed:@"infor_article_dislike_pre"] forState:UIControlStateSelected];
    
    [_dislikeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    
    [_dislikeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
    
    [_dislikeButton addTarget:self action:@selector(dislikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_dislikeButton];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    CGFloat margin = self.width / 4;
    
    //赞按钮
    
    _praiseButton.sd_layout
    .centerXIs(margin)
    .centerYEqualToView(self)
    .widthIs(130)
    .heightIs(40);
    
    //不喜欢按钮
    
    _dislikeButton.sd_layout
    .centerXIs(margin * 3)
    .centerYEqualToView(self)
    .widthIs(130)
    .heightIs(40);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.contentView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.praiseButton.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.dislikeButton.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
}

#pragma mark - 赞按钮点击事件

- (void)praiseButtonAction:(UIButton *)sender{
    
    if (!self.dislikeButton.selected && !sender.selected) {
        
        self.model.praiseCount += 1;
        
        NSString *praiseCountString = [self countStringHandle:self.model.praiseCount];
        
        praiseCountString = [NSString stringWithFormat:@"上头条 %@" , praiseCountString];
        
        [self.praiseButton setTitle:praiseCountString forState:UIControlStateSelected];
        
        self.praiseButton.selected = YES;
        
        [self plusAnimationWithButton:self.praiseButton];
    }
    
}

#pragma mark - 不喜欢按钮点击事件

- (void)dislikeButtonAction:(UIButton *)sender{
    
    if (!self.praiseButton.selected && !sender.selected) {
        
        self.model.dislikeCount += 1;
        
        NSString *dislikeCountString = [self countStringHandle:self.model.dislikeCount];
        
        dislikeCountString = [NSString stringWithFormat:@"不喜欢 %@" , dislikeCountString];
        
        [self.dislikeButton setTitle:dislikeCountString forState:UIControlStateSelected];
        
        self.dislikeButton.selected = YES;
        
        [self plusAnimationWithButton:self.dislikeButton];
    }
    
}

- (void)setModel:(NewsDetailsModel *)model{
    
    _model = model;
    
    // 每个文章的点赞的状态应该在本地存储一份 这里不多做演示 点到为止
    
    if (model.praiseCount) {
        
        NSString *praiseCountString = [NSString stringWithFormat:@"上头条 %@" , [self countStringHandle:model.praiseCount]];
        
        [self.praiseButton setTitle:praiseCountString forState:UIControlStateNormal];
    }
    
    if (model.dislikeCount) {
        
        NSString *dislikeCountString = [NSString stringWithFormat:@"不喜欢 %@" , [self countStringHandle:model.dislikeCount]];
        
        [self.dislikeButton setTitle:dislikeCountString forState:UIControlStateNormal];
    }
    
}

- (NSString *)countStringHandle:(NSInteger)count{
    
    NSString *countString = nil;
    
    // 超限处理
    
    if (count > 9999) {
        
        NSInteger wan = count / 10000;
        
        NSInteger qian = (count - wan * 10000) / 1000;
        
        if (qian && wan < 100) {
            
            countString = [NSString stringWithFormat:@"%ld.%ld万", wan , qian];
            
        } else {
            
            countString = [NSString stringWithFormat:@"%ld万", wan];
        }
        
    } else {
        
        countString = [NSString stringWithFormat:@"%ld", count];
    }
    
    return countString;
}

- (void)plusAnimationWithButton:(UIButton *)button{
    
    // 初始化label
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"+1";
    
    label.textColor = LEEColorRGB(229, 93, 93);
    
    [self addSubview:label];
    
    // 获取按钮的label在当前视图中的位置
    
    CGRect rect = [self convertRect:button.titleLabel.frame fromView:button];
    
    label.frame = CGRectMake(rect.origin.x + rect.size.width - 20, rect.origin.y, 20, 20);
    
    // 设置位移动画
    
    [UIView animateWithDuration:0.5f animations:^{
        
        label.top -= button.height;
        
        label.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [label removeFromSuperview];
    }];
    
}


@end
