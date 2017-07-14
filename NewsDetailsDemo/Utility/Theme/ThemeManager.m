//
//  ThemeManager.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

+ (void)changeTheme{
    
    // 覆盖截图
    
    UIView *tempView = [[UIApplication sharedApplication].delegate.window snapshotViewAfterScreenUpdates:NO];
    
    [[UIApplication sharedApplication].delegate.window addSubview:tempView];
    
    // 切换主题
    
    if ([[LEETheme currentThemeTag] isEqualToString:THEME_DAY]) {
        
        [LEETheme startTheme:THEME_NIGHT];
        
    } else {
        
        [LEETheme startTheme:THEME_DAY];
    }
    
    // 增加动画 移除覆盖
    
    [UIView animateWithDuration:1.0f animations:^{
        
        tempView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [tempView removeFromSuperview];
    }];
}

@end
