//
//  SettingModel.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/20.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SettingType) {
    /** 设置类型 字号 */
    SettingTypeFontSize,
    /** 设置类型 Wifi */
    SettingTypeWifi,
    /** 设置类型 缓存 */
    SettingTypeCache
};

@interface SettingModel : NSObject

/**
 类型
 */
@property (nonatomic , assign ) SettingType type;

/**
 标题
 */
@property (nonatomic , strong ) NSString *title;

/**
 副标题
 */
@property (nonatomic , strong ) NSString *subTitle;

/**
 是否显示箭头
 */
@property (nonatomic , assign ) BOOL showAcc;

/**
 是否显示开关
 */
@property (nonatomic , assign ) BOOL showSwitch;

/**
 开关的值
 */
@property (assign , nonatomic ) BOOL switchValue;

@end
