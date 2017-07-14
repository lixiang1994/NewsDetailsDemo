//
//  NewsDetailsCommentCell.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsCommentCell.h"

#import "SDAutoLayout.h"

#import "LEECoolButton.h"

@interface NewsDetailsCommentCell ()

@property (nonatomic , strong ) UIImageView *headImageView; //头像

@property (nonatomic , strong ) UILabel *nicknameLabel; //昵称

@property (nonatomic , strong ) UILabel *timeLabel; //时间

@property (nonatomic , strong ) UIView *contentContainer; // 评论内容容器

@property (nonatomic , strong ) UILabel *contentLabel; // 评论内容Label

@property (nonatomic , strong ) LEECoolButton *praiseButton; //赞按钮

@property (nonatomic , strong ) UIView *subCommentContainer; //子评论容器

@property (nonatomic , strong ) UILabel *subCommentLabel; //子评论

@property (nonatomic , strong ) UIView *bottomLineView; //底部分隔线视图

@end

@implementation NewsDetailsCommentCell


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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    // 头像
    
    _headImageView = [[UIImageView alloc] init];
    
    _headImageView.sd_cornerRadiusFromHeightRatio = @0.5f;
    
    [self.contentView addSubview:_headImageView];
    
    // 标题
    
    _nicknameLabel = [[UILabel alloc] init];
    
    _nicknameLabel.numberOfLines = 1;
    
    _nicknameLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:_nicknameLabel];
    
    // 赞
    
    _praiseButton = [LEECoolButton coolButtonWithImage:nil ImageFrame:CGRectMake(47, 6, 16, 16)];
    
    _praiseButton.imageOn = [UIImage imageNamed:@"infor_comment_praise_sel"];
    
    _praiseButton.imageOff = [UIImage imageNamed:@"infor_comment_praise_nor"];
    
    _praiseButton.circleColor = LEEColorHex(@"E35E60");
    
    _praiseButton.lineColor = [LEEColorHex(@"E35E60") colorWithAlphaComponent:0.9f];
    
    _praiseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    _praiseButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [_praiseButton addTarget:self action:@selector(praiseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_praiseButton];
    
    // 内容容器
    
    _contentContainer = [[UIView alloc] init];
    
    [self.contentView addSubview:_contentContainer];
    
    // 内容
    
    _contentLabel = [[UILabel alloc] init];
    
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.contentContainer addSubview:_contentLabel];
    
    // 时间
    
    _timeLabel = [[UILabel alloc] init];
    
    _timeLabel.numberOfLines = 1;
    
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [self.contentView addSubview:_timeLabel];
    
    // 子评论视图
    
    _subCommentContainer = [[UIView alloc] init];
    
    [self.contentView addSubview:_subCommentContainer];
    
    // 子评论
    
    _subCommentLabel = [[UILabel alloc] init];
    
    _subCommentLabel.isAttributedContent = YES;
    
    [self.subCommentContainer addSubview:_subCommentLabel];
    
    // 底部分隔线视图
    
    _bottomLineView = [UIView new];
    
    [self.contentView addSubview:_bottomLineView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 头像
    
    _headImageView.sd_layout
    .topSpaceToView(self.contentView , 15.0f)
    .leftSpaceToView(self.contentView , 15.0f)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    // 昵称
    
    _nicknameLabel.sd_layout
    .centerYEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView , 10.0f)
    .rightSpaceToView(self.contentView , 75.0f)
    .heightIs(20.0f);
    
    // 赞
    
    _praiseButton.sd_layout
    .rightSpaceToView(self.contentView, 15.0f)
    .centerYEqualToView(self.nicknameLabel)
    .widthIs(60.0f)
    .heightIs(30.0f);
    
    // 内容容器
    
    _contentContainer.sd_layout
    .topSpaceToView(self.headImageView, 10.0f)
    .leftSpaceToView(self.headImageView, 10.0f)
    .rightSpaceToView(self.contentView, 15.0f)
    .heightIs(0.0f);
    
    // 内容
    
    _contentLabel.sd_layout
    .topSpaceToView(self.contentContainer, 0.0f)
    .leftSpaceToView(self.contentContainer, 0.0f)
    .rightSpaceToView(self.contentContainer, 0.0f)
    .autoHeightRatio(0);
    
    [_contentContainer setupAutoHeightWithBottomView:self.contentLabel bottomMargin:0.0f];
    
    // 时间
    
    _timeLabel.sd_layout
    .topSpaceToView(self.contentContainer, 10.0f)
    .leftEqualToView(self.contentContainer)
    .widthIs(60.0f)
    .heightIs(20.0f);
    
    // 子评论容器
    
    _subCommentContainer.sd_layout
    .topSpaceToView(self.timeLabel, 10.0f)
    .leftSpaceToView(self.headImageView, 10.0f)
    .rightSpaceToView(self.contentView, 15.0f)
    .heightIs(0.0f);
    
    // 子评论
    
    _subCommentLabel.sd_layout
    .topSpaceToView(self.subCommentContainer, 10.0f)
    .leftSpaceToView(self.subCommentContainer, 10.0f)
    .rightSpaceToView(self.subCommentContainer, 10.0f)
    .autoHeightRatio(0);
    
    [_subCommentContainer setupAutoHeightWithBottomView:self.subCommentLabel bottomMargin:10.0f];
    
    // 底部分隔线
    
    _bottomLineView.sd_layout
    .topSpaceToView(self.subCommentContainer , 15.0f)
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
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_1B1B1B);
    
    self.bottomLineView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_E8E8E8)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
    
    self.headImageView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333)
    .LeeAddCustomConfig(THEME_DAY , ^(UIImageView *item){
        item.alpha = 1.0f;
    })
    .LeeAddCustomConfig(THEME_NIGHT , ^(UIImageView *item){
        item.alpha = 0.7f;
    });
    
    self.nicknameLabel.lee_theme
    .LeeAddTextColor(THEME_DAY , HEX_222222)
    .LeeAddTextColor(THEME_NIGHT , HEX_777777)
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
    
    self.praiseButton.lee_theme
    .LeeAddButtonTitleColor(THEME_DAY, LEEColorHex(HEX_999999), UIControlStateNormal)
    .LeeAddButtonTitleColor(THEME_NIGHT, LEEColorHex(HEX_777777), UIControlStateNormal)
    .LeeAddButtonTitleColor(THEME_DAY, self.praiseButton.circleColor, UIControlStateSelected)
    .LeeAddButtonTitleColor(THEME_NIGHT, self.praiseButton.circleColor, UIControlStateSelected);
    
    self.contentLabel.lee_theme
    .LeeAddTextColor(THEME_DAY , HEX_222222)
    .LeeAddTextColor(THEME_NIGHT , HEX_777777);
    
    self.timeLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_555555)
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
    
    self.contentContainer.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
    
    self.subCommentContainer.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_F3F3F3)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_333333);
}

#pragma mark - 赞按钮点击事件

- (void)praiseButtonAction:(LEECoolButton *)sender{
    
    if (sender.selected) {
        
        [sender deselect];
        
        self.model.praiseCount -= 1;
        
    } else {
        
        [sender select];
        
        self.model.praiseCount += 1;
    }
    
    self.model.isPraise = sender.selected;
    
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%ld" , self.model.praiseCount] forState:UIControlStateNormal];
}

#pragma mark - 获取数据

- (void)setModel:(NewsDetailsCommentModel *)model{
    
    _model = model;
    
    self.nicknameLabel.text = model.nickname;
    
    self.timeLabel.text = model.time;
    
    self.contentLabel.text = model.content;
    
    self.praiseButton.selected = model.isPraise;
    
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%ld" , model.praiseCount] forState:UIControlStateNormal];
    
    NSMutableAttributedString *subComment = [[NSMutableAttributedString alloc] init];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 6.5f;
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13.0f] ,
                                 NSParagraphStyleAttributeName : paragraphStyle ,
                                 NSBackgroundColorAttributeName : [UIColor clearColor] ,
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    for (NewsDetailsCommentModel *subModel in model.subCommentArray) {
        
        NSString *subCommentContent = model.subCommentArray.lastObject == subModel ? subModel.content : [subModel.content stringByAppendingString:@"\n"];
        
        [subComment appendAttributedString:[[NSAttributedString alloc] initWithString:subCommentContent attributes:attributes]];
    }
    
    self.subCommentLabel.attributedText = subComment;
    
    if (model.subCommentArray.count) {
        
        self.subCommentContainer.hidden = NO;
        
        self.bottomLineView.sd_layout.topSpaceToView(self.subCommentContainer, 15.0f);
        
    } else {
        
        self.subCommentContainer.hidden = YES;
        
        self.bottomLineView.sd_layout.topSpaceToView(self.timeLabel, 15.0f);
    }
    
}

@end
