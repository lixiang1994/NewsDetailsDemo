//
//  NewsDetailsCommentModel.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailsCommentModel : NSObject <YYModel>

/**
 评论Id
 */
@property (nonatomic , copy ) NSString *commentId;

/**
 评论人昵称
 */
@property (nonatomic , copy ) NSString *nickname;

/**
 评论内容
 */
@property (nonatomic , copy ) NSString *content;

/**
 评论时间
 */
@property (nonatomic , copy ) NSString *time;

/**
 评论点赞数
 */
@property (nonatomic , assign ) NSInteger praiseCount;

/**
 评论子评论数组
 */
@property (nonatomic , strong ) NSArray *subCommentArray;

#pragma mark - 扩展

/**
 评论是否已经点赞
 */
@property (nonatomic , assign ) BOOL isPraise;

@end
