//
//  ContentManager.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ContentImageLoadState) {
    
    /** 内容图片加载状态 初始 */
    ContentImageLoadStateInitial    = 0 ,
    /** 内容图片加载状态 加载中 */
    ContentImageLoadStateLoading    = 1,
    /** 内容图片加载状态 点击加载 */
    ContentImageLoadStateClick      = 2,
    /** 内容图片加载状态 加载失败 */
    ContentImageLoadStateFailure    = 3,
    /** 内容图片加载状态 加载完成*/
    ContentImageLoadStateFinish     = 4,
    /** 内容图片加载状态 Gif*/
    ContentImageLoadStateGif        = 5,
};

typedef NS_ENUM(NSInteger, ContentImageLoadMode) {
    
    /** 内容图片加载状态 全部加载 */
    ContentImageLoadModeAll    = 0 ,
    /** 内容图片加载模式 滑动加载 */
    ContentImageLoadModeScroll    = 1,
};

@interface ContentManager : NSObject

/**
 初始化数据
 */
+ (void)initData;

/**
 获取TEMP缓存目录
 
 @return 缓存路径
 */
+ (NSString *)getCachePath;

/**
 获取TEMP缓存目录下指定文件夹的路径
 
 @param folder 文件夹名
 @return 缓存路径
 */
+ (NSString *)getCachePath:(NSString *)folder;

/**
 获取TEMP缓存目录下内容图片缓存路径
 
 @return 缓存路径
 */
+ (NSString *)getContentImageCachePath;

/**
 获取缓存图片文件路径 (纯路径)
 
 @param urlString 图片url
 @return 路径
 */
+ (NSString *)getCacheImageFilePath:(NSString *)urlString;

/**
 获取缓存图片文件路径 (如果不存在则会查询YY缓存 都不存在则返回nil)
 
 @param urlString 图片url
 @return 路径 不存在则为nil
 */
+ (NSString *)getCacheImageFilePathWithUrl:(NSString *)urlString;

/**
 加载图片
 
 @param url 链接
 @param resultBlock 结果回调Block
 */
+ (void)loadImage:(NSURL *)url ResultBlock:(void (^)(NSString * ,BOOL))resultBlock;

/**
 加载图片
 
 @param url 链接
 @param progressBlock 进度回调block
 @param resultBlock 结果回调Block
 */
+ (void)loadImage:(NSURL *)url ProgressBlock:(void (^)(CGFloat))progressBlock ResultBlock:(void (^)(NSString * ,BOOL))resultBlock;

/**
 清理缓存
 
 @param resultBlock 结果回调Block
 */
+ (void)clearCacheWithResultBlock:(void (^)())resultBlock;

/**
 是否加载图片
 
 @return YES or NO
 */
+ (BOOL)isLoadImage;

/**
 是否仅Wifi加载图片

 @return YES or NO
 */
+ (BOOL)isOnlyWifiLoad;

/**
 设置是否仅Wifi加载图片

 @param isOnlyWifiLoad YES or NO
 */
+ (void)setIsOnlyWifiLoad:(BOOL)isOnlyWifiLoad;

/**
 字体大小处理

 @param size 标准大小
 @return 处理后的大小
 */
+ (CGFloat)fontSize:(CGFloat)size;

+ (NSInteger)fontLevel;

+ (void)setFontLevel:(NSInteger)level;

@end
