//
//  SelectedListView.m
//  LEEAlertDemo
//
//  Created by 李响 on 2017/6/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "SelectedListView.h"

@interface SelectedListView ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong ) NSMutableArray *dataArray;

@end

@implementation SelectedListView

- (void)dealloc{
    
    _dataArray = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        //初始化数据
        
        [self initData];
    }
    
    return self;
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    self.bounces = NO;
    
    self.allowsMultipleSelectionDuringEditing = YES; //支持同时选中多行
    
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.separatorColor = [[UIColor grayColor] colorWithAlphaComponent:0.2f];
    
    self.dataArray = [NSMutableArray array];
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setArray:(NSArray<SelectedListModel *> *)array{
    
    _array = array;
    
    [self reloadData];
    
    [self setEditing:!self.isSingle animated:NO];
    
    CGRect selfFrame = self.frame;
    
    selfFrame.size.height = array.count * 50.0f;
    
    self.frame = selfFrame;
}

- (void)setIsSingle:(BOOL)isSingle{
    
    _isSingle = isSingle;
    
    [self setEditing:!isSingle animated:NO];
}

- (void)finish{
    
    if (self.selectedBlock) self.selectedBlock(self.dataArray);
}

- (void)show{
    
    [LEEAlert actionsheet].config
    .LeeTitle(@"举报内容问题")
    .LeeItemInsets(UIEdgeInsetsMake(20, 0, 20, 0))
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        custom.view = self;
        
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

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SelectedListModel *model = self.array[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectedBackgroundView = [UIView new];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    id model = self.array[indexPath.row];
    
    [self.dataArray addObject:model];
    
    if (self.isSingle) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self finish];
    
    } else {
        
        if (self.changedBlock) self.changedBlock(self.dataArray);
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    id model = self.array[indexPath.row];
    
    if (!self.isSingle) {
        
        [self.dataArray removeObject:model];
        
        if (self.changedBlock) self.changedBlock(self.dataArray);
    }
}

@end
