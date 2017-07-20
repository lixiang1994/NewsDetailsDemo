//
//  NewsDetailsModel.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailsModel : NSObject<YYModel , NSCoding>

/**
 资讯Id
 */
@property (nonatomic , copy ) NSString *newsId;

/**
 资讯标题
 */
@property (nonatomic , copy ) NSString *newsTitle;

/**
 资讯时间
 */
@property (nonatomic , copy ) NSString *newsTime;

/**
 资讯Html
 */
@property (nonatomic , copy ) NSString *newsHtml;

/**
 相关资讯
 */
@property (nonatomic , strong ) NSArray *aboutArray;

/**
 点赞数
 */
@property (nonatomic , assign ) NSInteger praiseCount;

/**
 不喜欢数
 */
@property (nonatomic , assign ) NSInteger dislikeCount;

#pragma mark - 扩展属性

/**
 是否点赞
 */
@property (nonatomic , assign ) BOOL isPraise;

/**
 是否不喜欢
 */
@property (nonatomic , assign ) BOOL isDislike;

#pragma mark - 缓存

+ (NewsDetailsModel *)cacheForNewsId:(NSString *)newsId;

+ (void)setCache:(NewsDetailsModel *)model forNewsId:(NSString *)newsId;

+ (void)cacheSizeWithBlock:(void (^)(NSInteger bytes))block;

+ (void)clearCacheForNewsId:(NSString *)newsId;

+ (void)clearAllCacheWithBlock:(void (^)())block;

@end
