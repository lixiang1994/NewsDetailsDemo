//
//  NavigationBar.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/9/22.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarStyleType) {
    
    /** 导航栏样式类型 正常 */
    NavigationBarStyleTypeNormal = 0,
    /** 导航栏样式类型 红色 */
    NavigationBarStyleTypeRed,
    /** 导航栏样式类型 白色*/
    NavigationBarStyleTypeWhite,
};

@interface NavigationBar : UIView

@property (nonatomic , strong ) UIView *contentView;

@property (nonatomic , assign ) NavigationBarStyleType navigationBarStyleType; //导航栏样式类型

@end
