//
//  NewsDetailsViewController.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsViewController.h"

#import "SDAutoLayout.h"

#import "MJRefresh.h"

#import "NewsDetailsAPI.h"

#import "NewsDetailsADCell.h"

#import "NewsDetailsShareCell.h"

#import "NewsDetailsPraiseCell.h"

#import "NewsDetailsRelateCell.h"

#import "NewsDetailsCommentCell.h"

#import "NewsDetailsHeaderFooterView.h"

#import "NewsDetailsHeaderView.h"

#import "HUD.h"

#import "AllShareView.h"

#import "FontSizeView.h"

#import "SelectedListView.h"

#import "ThemeManager.h"

@interface NewsDetailsViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) UIButton *moreButton;

@property (nonatomic , strong ) NewsDetailsHeaderView *headerView;

@property (nonatomic , strong ) UITableView *tableView;

@property (nonatomic , strong ) NSMutableArray *dataArray;

@property (nonatomic , strong ) NSMutableArray *commentArray;

@property (nonatomic , strong ) NewsDetailsAPI *api;

@property (nonatomic , strong ) NewsDetailsModel *model;

@property (nonatomic , assign ) NSInteger commentPage;

@end

static NSString *const NewsDetailsHeaderID = @"NewsDetailsHeader";

static NSString *const ADSectionID = @"ADSection";

static NSString *const ShareSectionID = @"ShareSection";

static NSString *const PraiseSectionID = @"PraiseSection";

static NSString *const RelateSectionID = @"RelateSection";

static NSString *const HotCommentSectionID = @"HotCommentSection";

static NSString *const AllCommentSectionID = @"AllCommentSection";

@implementation NewsDetailsViewController

- (void)dealloc{
    
    _dataArray = nil;
    
    _commentArray = nil;
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
    
    // 设置Block
    
    [self configBlock];
    
    // 设置刷新
    
    [self configRefresh];
    
    // 加载数据
    
    [self loadData];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.headerView updateHeight];
}

- (void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, VIEWSAFEAREAINSETS(self.view).bottom, 0);
}

#pragma mark - 设置NavigationBar

- (void)configNavigationBar{
    
    self.navigationBarStyleType = NavigationBarStyleTypeWhite;
    
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
    
    _api = [[NewsDetailsAPI alloc] init];
    
    _dataArray = [NSMutableArray array];
    
    _commentArray = [NSMutableArray arrayWithArray:@[[NSMutableArray array] , [NSMutableArray array]]];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationBar.contentView addSubview:_moreButton];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    
    _tableView.hidden = YES;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 50.0f, 0, 0);
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _tableView.estimatedRowHeight = 0;
    
    _tableView.estimatedSectionHeaderHeight = 0;
    
    _tableView.estimatedSectionFooterHeight = 0;
    
    [_tableView registerClass:[NewsDetailsADCell class] forCellReuseIdentifier:ADSectionID];
    
    [_tableView registerClass:[NewsDetailsShareCell class] forCellReuseIdentifier:ShareSectionID];
    
    [_tableView registerClass:[NewsDetailsPraiseCell class] forCellReuseIdentifier:PraiseSectionID];
    
    [_tableView registerClass:[NewsDetailsRelateCell class] forCellReuseIdentifier:RelateSectionID];
    
    [_tableView registerClass:[NewsDetailsCommentCell class] forCellReuseIdentifier:AllCommentSectionID];
    
    [_tableView registerClass:[NewsDetailsHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NewsDetailsHeaderID];
    
    [self.view addSubview:_tableView];
    
    
    _headerView = [[NewsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    self.tableView.tableHeaderView = _headerView;
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    self.moreButton.sd_layout
    .bottomSpaceToView(self.navigationBar.contentView , 7.0f)
    .rightSpaceToView(self.navigationBar.contentView , 7.0f)
    .widthIs(30.0f)
    .heightIs(30.0f);
    
    self.tableView.sd_layout
    .topSpaceToView(self.navigationBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0);
    
    self.headerView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthRatioToView(self.tableView, 1.0f);
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.view.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.moreButton.lee_theme
    .LeeAddButtonImage(THEME_DAY, [UIImage imageNamed:@"infor_nav_more_nor"], UIControlStateNormal)
    .LeeAddButtonImage(THEME_DAY, [UIImage imageNamed:@"infor_nav_more_pre"], UIControlStateHighlighted)
    .LeeAddButtonImage(THEME_NIGHT, [UIImage imageNamed:@"infor_nav_more_white_nor"], UIControlStateNormal)
    .LeeAddButtonImage(THEME_NIGHT, [UIImage imageNamed:@"infor_nav_more_white_pre"], UIControlStateHighlighted);
    
    self.tableView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
}

#pragma mark - 设置Block

- (void)configBlock{
    
    __weak typeof(self) weakSelf = self;

    self.headerView.loadedFinishBlock = ^(BOOL result) {
      
        if (!weakSelf) return ;
        
        if (result) {
            
            weakSelf.tableView.hidden = NO;
            
            weakSelf.tableView.alpha = 0.0f;
            
            [UIView animateWithDuration:0.3f animations:^{
                
                weakSelf.tableView.alpha = 1.0f;
            }];
            
        } else {
            
            // 加载失败 提示用户
        }
        
    };
    
    self.headerView.updateHeightBlock = ^(NewsDetailsHeaderView *view) {
      
        if (!weakSelf) return ;
        
        weakSelf.tableView.tableHeaderView = view;
    };
    
}

#pragma mark - 设置刷新

- (void)configRefresh{
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
       
        if (!weakSelf) return ;
        
        CATransition *transtion = [CATransition animation];
        
        transtion.duration = 0.3f;
        
        transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        transtion.type = kCATransitionReveal;
        
        transtion.subtype = kCATransitionFromBottom;
        
        [weakSelf.navigationController.view.layer addAnimation:transtion forKey:nil];
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
        
        /** 淡出
        [UIView transitionWithView:self.navigationController.view duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
        } completion:nil];
         */
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setTitle:@"下拉关闭页面" forState:MJRefreshStateIdle];
    
    [header setTitle:@"释放关闭页面" forState:MJRefreshStateRefreshing];
    
    [header setTitle:@"释放关闭页面" forState:MJRefreshStatePulling];
    
    // 设置字体
    
    header.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    
    // 设置颜色
    
    header.stateLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_666666);
    
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (!weakSelf) return ;
        
        [weakSelf loadCommentDataWithPage:weakSelf.commentPage ? weakSelf.commentPage + 1 : 1 ResultBlock:^(NSInteger result) {
            
            if (!weakSelf) return ;
            
            switch (result) {
                    
                case 0:
                    
                    // 加载失败 (这里可以给用户一个提示)
                    
                    [weakSelf.view showMessage:@"加载失败 请重试"];
                    
                    [weakSelf.tableView.mj_footer endRefreshing];
                    
                    break;
                    
                case 1:
                    
                    // 加载成功
                    
                    [weakSelf.tableView.mj_footer endRefreshing];
                    
                    break;
                    
                case 2:
                    
                    // 无更多数据
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }];
    
    [footer setTitle:@"加载评论" forState:MJRefreshStateIdle];
    
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    
    [footer setTitle:@"没有更多评论" forState:MJRefreshStateNoMoreData];
    
    footer.automaticallyHidden = YES;
    
    // 设置字体
    
    footer.stateLabel.font = [UIFont systemFontOfSize:14.0f];
    
    // 设置颜色
    
    footer.stateLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_666666);
    
    // 设置菊花样式
    
    footer.lee_theme
    .LeeAddCustomConfig(THEME_DAY , ^(MJRefreshAutoNormalFooter *item){
        
        item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    })
    .LeeAddCustomConfig(THEME_NIGHT , ^(MJRefreshAutoNormalFooter *item){
        
        item.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    });
    
    self.tableView.mj_footer = footer;
}

#pragma mark - 加载数据

- (void)loadData{
    
    __weak typeof(self) weakSelf = self;
    
    [self.api loadDataWithNewsId:self.newsId ResultBlock:^(NewsDetailsModel *model) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return ;
        
        if (model) {
            
            strongSelf.model = model;
            
            strongSelf.headerView.model = model;
            
            [strongSelf.dataArray addObject:ADSectionID];
            
            [strongSelf.dataArray addObject:ShareSectionID];
            
            [strongSelf.dataArray addObject:PraiseSectionID];
            
            if (strongSelf.model.aboutArray.count) [strongSelf.dataArray addObject:RelateSectionID];
            
            [strongSelf.tableView reloadData];
            
            // 加载评论数据
            
            // [strongSelf.tableView.mj_footer beginRefreshing];
        
        } else {
            
            // 请求失败 提示用户
        }
        
    }];
    
}

#pragma mark - 加载评论数据

- (void)loadCommentDataWithPage:(NSInteger)page ResultBlock:(void (^)(NSInteger result))resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    [self.api loadCommentDataWithPage:page ResultBlock:^(NSArray *array) {
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return ;
        
        // 暂定 array不为空时是请求成功 为空时是请求失败. 正常请求接口应该有一个状态 这里不多演示
        
        if (array) {
            
            // 同步页数
            
            strongSelf.commentPage = page;
            
            // 获取热门和全部评论数组
            
            NSMutableArray *hotArray = strongSelf.commentArray.firstObject;
            
            NSMutableArray *allArray = strongSelf.commentArray.lastObject;
            
            NSArray *hot = array.firstObject;
            
            NSArray *all = array.lastObject;
            
            // 插入或刷新分组
            
            if (hot.count) {
                
                [hotArray addObjectsFromArray:hot];
                
                if ([strongSelf.dataArray containsObject:HotCommentSectionID]) {
                    
                    [strongSelf.tableView beginUpdates];
                    
                    [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:[strongSelf.dataArray indexOfObject:HotCommentSectionID]] withRowAnimation:UITableViewRowAnimationNone];
                
                    [strongSelf.tableView endUpdates];
                    
                } else {
                    
                    [strongSelf.dataArray addObject:HotCommentSectionID];
                    
                    [strongSelf.tableView beginUpdates];
                    
                    [strongSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:strongSelf.dataArray.count - 1] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [strongSelf.tableView endUpdates];
                }
                
            }
            
            if (all.count) {
                
                if ([strongSelf.dataArray containsObject:AllCommentSectionID]) {
                    
                    NSInteger section = [strongSelf.dataArray indexOfObject:AllCommentSectionID];
                    
                    NSMutableArray *indexPathArray = [NSMutableArray array];
                    
                    for (NSInteger i = 0; i < all.count; i++) {
                        
                        [indexPathArray addObject:[NSIndexPath indexPathForRow:allArray.count + i inSection:section]];
                    }
                    
                    [allArray addObjectsFromArray:all];
                    
                    [strongSelf.tableView beginUpdates];
                    
                    [strongSelf.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
                    
                    [strongSelf.tableView endUpdates];
                    
                } else {
                    
                    [allArray addObjectsFromArray:all];
                    
                    [strongSelf.dataArray addObject:AllCommentSectionID];
                    
                    [strongSelf.tableView beginUpdates];
                    
                    [strongSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:strongSelf.dataArray.count - 1] withRowAnimation:UITableViewRowAnimationFade];
                    
                    [strongSelf.tableView endUpdates];
                }
                
            }
            
            if (resultBlock) resultBlock(all.count ? 1 : 2);
            
        } else {
            
            if (resultBlock) resultBlock(0);
        }
        
    }];
    
}

#pragma mark - 更多按钮点击事件

- (void)moreButtonAction{
    
    [self openShare];
}

#pragma mark - 打开分享

- (void)openShare{
    
    AllShareView *view = [[AllShareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) ShowMore:YES ShowReport:YES];
    
    view.openShareBlock = ^(ShareType type) {
        
        NSLog(@"%d" , type);
    };
    
    view.openMoreBlock = ^(MoreType type) {
        
        switch (type) {
                
            case MoreTypeToTheme:
                
                // 切换主题 (关于主题开源库 推荐一下: https://github.com/lixiang1994/LEETheme)
                [ThemeManager changeTheme];
                break;
                
            case MoreTypeToReport:
                
                // 打开举报
                [self openReport];
                
                break;
                
            case MoreTypeToFontSize:
                
                // 打开字体设置
                [self openFontSize];
                
                break;
                
            case MoreTypeToCopyLink:
                
                // 复制链接
                
                break;
                
            default:
                break;
        }
        
    };
    
    // 显示代码可以封装到自定义视图中 例如 [view show];
    
    [LEEAlert actionsheet].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        custom.view = view;
        
        custom.isAutoWidth = YES;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddAction(^(LEEAction *action) {
        
        action.title = @"取消";
        
        action.titleColor = [UIColor grayColor];
        
        action.height = 45.0f;
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeActionSheetBottomMargin(0.0f)
    .LeeActionSheetBackgroundColor([UIColor whiteColor])
    .LeeCornerRadius(0.0f)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        
        [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            animatingBlock(); //调用动画中Block
            
        } completion:^(BOOL finished) {
            
            animatedBlock(); //调用动画结束Block
        }];
        
    })
    .LeeShow();
}

#pragma mark - 打开字号设置

- (void)openFontSize{
    
    __weak typeof(self) weakSelf = self;
    
    FontSizeView *view = [[FontSizeView alloc] init];
    
    view.currentIndex = [ContentManager fontLevel];
    
    view.changeBlock = ^(NSInteger level){
        
        if (!weakSelf) return ;
        
        [weakSelf.headerView configFontLevel:level];
    };
    
    [LEEAlert actionsheet].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        custom.view = view;
        
        custom.isAutoWidth = YES;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddAction(^(LEEAction *action) {
        
        action.title = @"取消";
        
        action.titleColor = [UIColor grayColor];
        
        action.height = 45.0f;
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeActionSheetBottomMargin(0.0f)
    .LeeActionSheetBackgroundColor([UIColor whiteColor])
    .LeeCornerRadius(0.0f)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        
        return type == LEEScreenOrientationTypeHorizontal ? CGRectGetHeight([[UIScreen mainScreen] bounds]) : CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeShow();
}

#pragma mark - 打开举报

- (void)openReport{
    
    SelectedListView *view = [[SelectedListView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0) style:UITableViewStylePlain];
    
    view.isSingle = YES;
    
    view.array = @[[[SelectedListModel alloc] initWithSid:0 Title:@"垃圾广告"] ,
                   [[SelectedListModel alloc] initWithSid:1 Title:@"淫秽色情"] ,
                   [[SelectedListModel alloc] initWithSid:2 Title:@"低俗辱骂"] ,
                   [[SelectedListModel alloc] initWithSid:3 Title:@"涉政涉密"] ,
                   [[SelectedListModel alloc] initWithSid:4 Title:@"欺诈谣言"] ];
    
    view.selectedBlock = ^(NSArray<SelectedListModel *> *array) {
        
        [LEEAlert closeWithCompletionBlock:^{
            
            NSLog(@"选中的%@" , array);
        }];
        
    };
    
    [LEEAlert actionsheet].config
    .LeeTitle(@"举报内容问题")
    .LeeItemInsets(UIEdgeInsetsMake(20, 0, 20, 0))
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        custom.view = view;
        
        custom.isAutoWidth = YES;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddAction(^(LEEAction *action) {
        
        action.title = @"取消";
        
        action.titleColor = [UIColor blackColor];
        
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeHeaderColor([UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f])
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeActionSheetBackgroundColor([UIColor whiteColor])
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeShow();
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
    
    NSString *sectionIdent = self.dataArray[section];
    
    if ([sectionIdent isEqualToString:ADSectionID]) {
        
        return 1;
        
    } else if ([sectionIdent isEqualToString:ShareSectionID]) {
        
        return 1;
        
    } else if ([sectionIdent isEqualToString:PraiseSectionID]) {
        
        return 1;
        
    } else if ([sectionIdent isEqualToString:RelateSectionID]) {
        
        return self.model.aboutArray.count;
        
    } else if ([sectionIdent isEqualToString:HotCommentSectionID]) {
        
        return [self.commentArray.firstObject count];
        
    } else if ([sectionIdent isEqualToString:AllCommentSectionID]) {
        
        return [self.commentArray.lastObject count];
        
    } else {
        
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *sectionIdent = self.dataArray[indexPath.section];
    
    if ([sectionIdent isEqualToString:ADSectionID]) {
        
        return [tableView cellHeightForIndexPath:indexPath model:nil keyPath:@"model" cellClass:[NewsDetailsADCell class] contentViewWidth:tableView.width];
        
    } else if ([sectionIdent isEqualToString:ShareSectionID]) {
        
        return 0.0f;
        
    } else if ([sectionIdent isEqualToString:PraiseSectionID]) {
        
        return 100.0f;
        
    } else if ([sectionIdent isEqualToString:RelateSectionID]) {
        
        return [tableView cellHeightForIndexPath:indexPath model:self.model.aboutArray[indexPath.row] keyPath:@"model" cellClass:[NewsDetailsRelateCell class] contentViewWidth:tableView.width];
        
    } else if ([sectionIdent isEqualToString:HotCommentSectionID]) {
        
        id model = self.commentArray[0][indexPath.row];
        
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewsDetailsCommentCell class] contentViewWidth:tableView.width];
        
    } else if ([sectionIdent isEqualToString:AllCommentSectionID]) {
        
        id model = self.commentArray[1][indexPath.row];
        
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewsDetailsCommentCell class] contentViewWidth:tableView.width];
        
    } else {
        
        return 0.0f;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString *sectionIdent = self.dataArray[section];
    
    if ([sectionIdent isEqualToString:RelateSectionID]) {
        
        return 50.0f;
        
    } else if ([sectionIdent isEqualToString:HotCommentSectionID]) {
        
        return 50.0f;
        
    } else if ([sectionIdent isEqualToString:AllCommentSectionID]) {
        
        return 50.0f;
        
    }
    
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *sectionIdent = self.dataArray[section];
    
    if ([sectionIdent isEqualToString:RelateSectionID]) {
        
        NewsDetailsHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NewsDetailsHeaderID];
        
        [view configTitle:@"相关推荐"];
        
        return view;
        
    } else if ([sectionIdent isEqualToString:HotCommentSectionID]) {
        
        NewsDetailsHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NewsDetailsHeaderID];
        
        [view configTitle:@"热门评论"];
        
        return view;
        
    } else if ([sectionIdent isEqualToString:AllCommentSectionID]) {
        
        NewsDetailsHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NewsDetailsHeaderID];
        
        [view configTitle:@"全部评论"];
        
        return view;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *sectionIdent = self.dataArray[indexPath.section];
    
    if ([sectionIdent isEqualToString:ADSectionID]) {
        
        return [tableView dequeueReusableCellWithIdentifier:ADSectionID];
        
    } else if ([sectionIdent isEqualToString:ShareSectionID]) {
        
        return [tableView dequeueReusableCellWithIdentifier:ShareSectionID];
        
    } else if ([sectionIdent isEqualToString:PraiseSectionID]) {
        
        NewsDetailsPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:PraiseSectionID];
        
        cell.model = self.model;
        
        return cell;
        
    } else if ([sectionIdent isEqualToString:RelateSectionID]) {
        
        NewsDetailsRelateCell *cell = [tableView dequeueReusableCellWithIdentifier:RelateSectionID];
        
        cell.model = self.model.aboutArray[indexPath.row];
        
        return cell;
        
    } else if ([sectionIdent isEqualToString:HotCommentSectionID]) {
        
        NewsDetailsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:AllCommentSectionID];
        
        cell.model = self.commentArray[0][indexPath.row];
        
        return cell;
        
    } else if ([sectionIdent isEqualToString:AllCommentSectionID]) {
        
        NewsDetailsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:AllCommentSectionID];
        
        cell.model = self.commentArray[1][indexPath.row];
        
        return cell;
        
    } else {
        
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *sectionIdent = self.dataArray[indexPath.section];
    
    if ([sectionIdent isEqualToString:RelateSectionID]) {
    
        // 打开相关推荐
        
        NewsDetailsViewController *vc = [[NewsDetailsViewController alloc] init];
        
        vc.newsId = @"1995";
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 传递滑动
    
    [self.headerView scroll:scrollView.contentOffset];
}

@end
