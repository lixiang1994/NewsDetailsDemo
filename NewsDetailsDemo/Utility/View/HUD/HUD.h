//
//  HUD.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, HUDStatus) {
    
    /** 成功 */
    HUDStatusSuccess,
    
    /** 失败 */
    HUDStatusError,
    
    /** 提示 */
    HUDStatusInfo,
    
    /** 星标 */
    HUDStatusStar,
    
    /** 空心星标 */
    HUDStatusHollowStar,
    
    /** 等待 */
    HUDStatusWaitting
};

@interface HUD : MBProgressHUD

/** 返回一个 HUD 的单例 */
+ (instancetype)sharedHUD;

/** 在 window 上添加一个 HUD */
+ (void)showStatus:(HUDStatus)status text:(NSString *)text;

#pragma mark - 建议使用的方法

/** 在 window 上添加一个只显示文字的 HUD */
+ (void)showMessage:(NSString *)text;

/** 在 window 上添加一个提示`信息`的 HUD */
+ (void)showInfoMsg:(NSString *)text;

/** 在 window 上添加一个提示`失败`的 HUD */
+ (void)showFailure:(NSString *)text;

/** 在 window 上添加一个提示`成功`的 HUD */
+ (void)showSuccess:(NSString *)text;

/** 在 window 上添加一个提示`收藏成功`的 HUD */
+ (void)showAddFavorites:(NSString *)text;

/** 在 window 上添加一个提示`取消收藏`的 HUD */
+ (void)showRemoveFavorites:(NSString *)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */
+ (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hide;

@end


@interface UIView (HUD)

/** 在 view 上添加一个 HUD */
- (void)showStatus:(HUDStatus)status text:(NSString *)text;

#pragma mark - 建议使用的方法

/** 在 view 上添加一个只显示文字的 HUD */
- (void)showMessage:(NSString *)text;

/** 在 view 上添加一个提示`信息`的 HUD */
- (void)showInfoMsg:(NSString *)text;

/** 在 view 上添加一个提示`失败`的 HUD */
- (void)showFailure:(NSString *)text;

/** 在 view 上添加一个提示`成功`的 HUD */
- (void)showSuccess:(NSString *)text;

/** 在 view 上添加一个提示`收藏成功`的 HUD */
- (void)showAddFavorites:(NSString *)text;

/** 在 view 上添加一个提示`取消收藏`的 HUD */
- (void)showRemoveFavorites:(NSString *)text;

/** 在 view 上添加一个提示`等待`的 HUD, 需要手动关闭 */
- (void)showLoading:(NSString *)text;

/** 手动隐藏 HUD */
- (void)hide;

@end
