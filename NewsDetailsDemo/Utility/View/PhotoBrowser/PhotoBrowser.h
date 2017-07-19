//
//  PhotoBrowser.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowser : NSObject

/**
 图片Url数组
 */
@property (nonatomic , strong ) NSArray *imageUrlArray;

/**
 当前下标
 */
@property (nonatomic , assign ) NSInteger index;

/**
 图片所属视图 (可选)
 */
@property (nonatomic , weak ) UIView *imageView;

/**
 加载完成回调
 */
@property (nonatomic , copy ) void (^loadFinishBlock)(PhotoBrowser *, NSInteger index);

/**
 长按回调
 */
@property (nonatomic , copy ) void (^longClickBlock)(PhotoBrowser *, NSInteger index);

+ (PhotoBrowser *)browser;

- (void)saveImageWithIndex:(NSInteger)index;

- (void)show;

@end

















@interface PhotoBrowserViewController : UIViewController

@property (nonatomic , strong ) PhotoBrowser *browser;

- (void)saveImageWithIndex:(NSInteger)index;

- (void)show;

@end

@interface PhotoBrowserCell : UICollectionViewCell

@property (nonatomic , strong ) NSURL *url;

@property (nonatomic , copy ) void (^longClickBlock)();

@property (nonatomic , copy ) void (^loadFinishBlock)(NSURL *url , UIImage *image);

@property (nonatomic , copy ) void (^hideBlock)();

@end
