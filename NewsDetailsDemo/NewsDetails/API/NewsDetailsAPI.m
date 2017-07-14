//
//  NewsDetailsAPI.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsAPI.h"

@implementation NewsDetailsAPI

- (void)loadDataWithNewsId:(NSString *)newsId ResultBlock:(void (^)(NewsDetailsModel *model))resultBlock{
    
    // 这里模拟网络请求数据
    
    dispatch_async(dispatch_queue_create("requestQueue", DISPATCH_QUEUE_CONCURRENT), ^{
       
        NewsDetailsModel *model = [[NewsDetailsModel alloc] init];
        
        model.newsId = @"1994";
        
        model.newsTime = @"2小时前";
        
        model.newsTitle = @"标题";
        
        model.newsHtml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FakeData" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
        
        model.aboutArray = @[[NSNull null] ,
                             [NSNull null] ,
                             [NSNull null] ,
                             [NSNull null] ,
                             [NSNull null] ];
        
        model.praiseCount = arc4random_uniform(100000);
        
        model.dislikeCount = arc4random_uniform(100000);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (resultBlock) resultBlock(model);
        });
        
    });
    
}

- (void)loadCommentDataWithPage:(NSInteger)page ResultBlock:(void (^)(NSArray <NSArray *>*array))resultBlock{
    
    // 这里模拟网络请求数据
    
    dispatch_async(dispatch_queue_create("requestQueue", DISPATCH_QUEUE_CONCURRENT), ^{
        
        NSMutableArray *hotArray = [NSMutableArray array];
        
        NSMutableArray *allArray = [NSMutableArray array];
        
        // 模拟三页评论后 就没有了
        
        if (page < 4) {
            
            for (NSInteger i = (page - 1) * 10; i < page * 10; i++) {
                
                NewsDetailsCommentModel *model = [self createCommentModelWithCommentId:[NSString stringWithFormat:@"%ld" , i] IsSub:YES];
                
                [allArray addObject:model];
            }
            
        }
        
        // 模拟第一页评论时 有热门评论
        
        if (page == 1) {
            
            // 在全部评论中随机取几个当做热门评论
            
            NSInteger random = arc4random_uniform(9);
            
            [hotArray addObjectsFromArray:[allArray subarrayWithRange:NSMakeRange(random, allArray.count - random - 1)]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (resultBlock) resultBlock(@[hotArray , allArray]);
        });
        
    });

}

- (NewsDetailsCommentModel *)createCommentModelWithCommentId:(NSString *)commentId IsSub:(BOOL)isSub{
    
    NewsDetailsCommentModel *model = [[NewsDetailsCommentModel alloc] init];
    
    model.commentId = commentId;
    
    model.nickname = @" ";
    
    model.time = @" ";
    
    // 生成随机内容
    
    NSString *content = @"\n";
    
    for (NSInteger i = 0; i < arc4random_uniform(10); i++) {
        
        content = [content stringByAppendingString:@"\n"];
    }
    
    model.content = content;
    
    // 生成随机点赞数
    
    model.praiseCount = arc4random_uniform(1000);
    
    if (isSub) {
        
        // 生成随机子评论
        
        NSMutableArray *subArray = [NSMutableArray array];
        
        for (NSInteger s = 0; s < arc4random_uniform(4); s++) {
            
            NewsDetailsCommentModel *subModel = [self createCommentModelWithCommentId:[commentId stringByAppendingFormat:@"-%ld" , s] IsSub:NO];
            
            NSString *content = @"  ";
            
            for (NSInteger i = 0; i < arc4random_uniform(20) + 10; i++) {
                
                content = [content stringByAppendingString:@"   "];
            }
            
            subModel.content = content;
            
            [subArray addObject:subModel];
        }
        
        model.subCommentArray = subArray;
    }
    
    return model;
}

@end
