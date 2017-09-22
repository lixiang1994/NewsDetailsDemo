//
//  BaseViewController.h
//  Headlines
//
//  Created by 李响 on 2017/1/10.
//  Copyright © 2017年 ck. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDAutoLayout.h"

#import "NavigationBar.h"

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

typedef NS_ENUM(NSInteger, NavigationBarSubViewTag) {
    
    NavigationBarSubViewTagBackButton = 1000 , //返回按钮
    
    NavigationBarSubViewTagTitleLabel , //标题
};

@interface BaseViewController : UIViewController

@property (nonatomic , strong ) NavigationBar *navigationBar; //导航栏视图

@property (nonatomic , assign ) NavigationBarStyleType navigationBarStyleType; //导航栏样式类型

@property (nonatomic , copy ) void (^backBlock)(); //返回Back (非空是自动添加返回按钮)

/**
 初始化时导航栏
 */
- (void)initNavigationBar;

/**
 更新标题
 */
- (void)updateTitle;

@end
