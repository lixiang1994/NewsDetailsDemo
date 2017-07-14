//
//  NewsDetailsHeaderView.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsDetailsModel.h"

@interface NewsDetailsHeaderView : UIView

@property (nonatomic , strong ) NewsDetailsModel *model;

@property (nonatomic , copy ) void (^loadedFinishBlock)(BOOL);//加载完成Block

@property (nonatomic , copy ) void (^updateHeightBlock)(NewsDetailsHeaderView *view); //更新高度Block

@end
