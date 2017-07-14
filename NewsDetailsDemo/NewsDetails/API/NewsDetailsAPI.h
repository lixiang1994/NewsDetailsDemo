//
//  NewsDetailsAPI.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewsDetailsModel.h"

#import "NewsDetailsCommentModel.h"

@interface NewsDetailsAPI : NSObject

/**
 加载数据

 @param newsId 资讯Id
 @param resultBlock 结果回调Block
 */
- (void)loadDataWithNewsId:(NSString *)newsId ResultBlock:(void (^)(NewsDetailsModel *model))resultBlock;

/**
 加载评论数据

 @param page 页数
 @param resultBlock 结果回调Block
 */
- (void)loadCommentDataWithPage:(NSInteger)page ResultBlock:(void (^)(NSArray <NSArray *>*array))resultBlock;

@end
