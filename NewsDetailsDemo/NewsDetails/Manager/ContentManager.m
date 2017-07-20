//
//  ContentManager.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ContentManager.h"

@implementation ContentManager

+ (void)initData{
    
    // 获取资源文件
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    // 获取临时缓存目录
    
    NSString *jqueryJSPath = [[ContentManager getCachePath:@"js"] stringByAppendingPathComponent:@"jquery.min.js"];
    
    NSString *radialIndicatorJSPath = [[ContentManager getCachePath:@"js"] stringByAppendingPathComponent:@"radialIndicator.js"];
    
    NSString *webContentHandleJSPath = [[ContentManager getCachePath:@"js"] stringByAppendingPathComponent:@"WebContentHandle.js"];
    
    NSString *webContentStyleCSSPath = [[ContentManager getCachePath:@"css"] stringByAppendingPathComponent:@"WebContentStyle.css"];
    
    // 写入临时缓存目录
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:jqueryJSPath]) {
        
        NSString *jqueryJS = [NSString stringWithContentsOfFile:[mainBundle pathForResource:@"jquery.min" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL]; //jqueryJS
        
        [jqueryJS writeToFile:jqueryJSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:radialIndicatorJSPath]) {
        
        NSString *radialIndicatorJS = [NSString stringWithContentsOfFile:[mainBundle pathForResource:@"radialIndicator" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL]; //radialIndicatorJS
        
        [radialIndicatorJS writeToFile:radialIndicatorJSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:webContentHandleJSPath]) {
        
        NSString *webContentHandleJS = [NSString stringWithContentsOfFile:[mainBundle pathForResource:@"WebContentHandle" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL]; //web内容处理JS
        
        [webContentHandleJS writeToFile:webContentHandleJSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:webContentStyleCSSPath]) {
        
        NSString *webContentStyleCSS = [NSString stringWithContentsOfFile:[mainBundle pathForResource:@"WebContentStyle" ofType:@"css"] encoding:NSUTF8StringEncoding error:NULL];
        
        [webContentStyleCSS writeToFile:webContentStyleCSSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
    // 加载状态图片处理
    
    NSArray *imageArray = @[@"load_image_gif_icon.png" , @"load_image.png"];
    
    for (NSString *imageName in imageArray) {
        
        NSString *imagePath = [[ContentManager getDefaultImageCachePath] stringByAppendingPathComponent:imageName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            
            [[NSData dataWithContentsOfURL:[[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:imageName]] writeToFile:imagePath atomically:YES];
        }
        
    }
    
}

#pragma mark - 获取缓存路径

+ (NSString *)getCachePath:(NSString *)folder{
    
    // 缓存目录结构: temp/com.lee.content/[folder]
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [NSString stringWithFormat:@"%@%@/%@" , NSTemporaryDirectory() , @"com.lee.content" , folder ? folder : @""];
    
    // 判断该文件夹是否存在
    
    if(![fileManager fileExistsAtPath:filePath]){
        
        // 不存在创建文件夹 创建文件夹
        
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}

+ (NSString *)getCachePath{
    
    return [self getCachePath:nil];
}

+ (NSString *)getContentImageCachePath{
    
    // 缓存目录结构: temp/com.lee.content/contentimage/
    
    return [self getCachePath:@"contentimage"];
}

+ (NSString *)getDefaultImageCachePath{
    
    // 缓存目录结构: temp/com.lee.content/defaultimage/
    
    return [self getCachePath:@"defaultimage"];
}

#pragma mark - 获取缓存文件路径

+ (NSString *)getCacheImageFilePath:(NSString *)urlString{
    
    // 缓存目录结构: temp/com.lee.content/contentimage/md5url
    
    return [[self getContentImageCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@" , [urlString md5String]]];
}

+ (NSString *)getCacheImageFilePathWithUrl:(NSString *)urlString{
    
    // 查询缓存
    
    NSString *cachePath = [self getCacheImageFilePath:urlString];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        
        return cachePath;
        
    } else {
        
        // 查询YYWebImage缓存
        
        NSString *key = [[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlString]];
        
        if ([[YYWebImageManager sharedManager].cache containsImageForKey:key]) {
            
            NSData *imageData = [[YYWebImageManager sharedManager].cache getImageDataForKey:key];
            
            if (imageData.length) {
                
                // 写入临时缓存目录
                
                [imageData writeToFile:cachePath atomically:YES];
                
                return cachePath;
                
            } else {
                
                return nil;
            }
            
        } else {
            
            return nil;
        }
        
    }
    
}

#pragma mark - 清理缓存

+ (void)clearCacheWithResultBlock:(void (^)())resultBlock{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        [manager removeItemAtPath:[self getCachePath] error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultBlock) resultBlock();
        });
        
    });
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /**
         
         加载流程
         1.查询临时缓存目录是否存在
         2.存在则不再执行 (因为存在说明已经在webview中显示了)
         3.不存在则查询YYWebImage缓存目录是否存在
         4.存在则添加到临时缓存目录
         5.不存则开始请求图片资源并添加到YYWebImage缓存目录和临时缓存目录
         
         注: wkwebview只能加载出temp临时缓存目录下的本地资源 所以这里将图片缓存移到temp目录下
         
         */
        
    }
    return self;
}

#pragma mark - 加载图片

+ (void)loadImage:(NSURL *)url ResultBlock:(void (^)(NSString * ,BOOL))resultBlock{
    
    [self loadImage:url ProgressBlock:nil ResultBlock:resultBlock];
}

+ (void)loadImage:(NSURL *)url ProgressBlock:(void (^)(CGFloat))progressBlock ResultBlock:(void (^)(NSString * ,BOOL))resultBlock{
    
    if (!url) return;
    
    NSString *cachePath = [ContentManager getCacheImageFilePath:url.absoluteString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        
        [[YYWebImageManager sharedManager] requestImageWithURL:url options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (progressBlock) progressBlock((CGFloat)receivedSize / (CGFloat)expectedSize);
            });
            
        } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            return image;
            
        } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (resultBlock) resultBlock(nil , NO);
                });
                
            } else {
                
                // 写入临时缓存目录
                
                [[image imageDataRepresentation] writeToFile:cachePath atomically:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (resultBlock) resultBlock(cachePath , YES);
                });
            }
            
        }];
        
    }
    
}

+ (BOOL)isLoadImage{
    
    BOOL result = NO;
    
    // 一般用于控制非WIFI情况的图片加载
    
    if ([ContentManager isOnlyWifiLoad]) {
        
        if ([YYReachability reachability].status == YYReachabilityStatusWiFi) {
            
            result = YES;
            
        } else {
            
            result = NO;
        }
        
    } else {
        
        result = YES;
    }
    
    return result;
}

+ (BOOL)isOnlyWifiLoad{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isOnlyWifiLoad"];
}

+ (void)setIsOnlyWifiLoad:(BOOL)isOnlyWifiLoad{
    
    [[NSUserDefaults standardUserDefaults] setBool:isOnlyWifiLoad forKey:@"isOnlyWifiLoad"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)fontSize:(CGFloat)size{
    
    CGFloat fontSize = 0.0f;
    
    CGFloat width = CGRectGetHeight([[UIScreen mainScreen] bounds]) > CGRectGetWidth([[UIScreen mainScreen] bounds]) ? CGRectGetWidth([[UIScreen mainScreen] bounds]) : CGRectGetHeight([[UIScreen mainScreen] bounds]);
    
    switch ((NSInteger)width) {
            
        case 320:
            
            fontSize = size * 1.0f;
            
            break;
            
        case 375:
            
            fontSize = size * 1.05f;
            
            break;
            
        case 414:
            
            fontSize = size * 1.1f;
            
            break;
            
        default:
            
            fontSize = size * 1.0f;
            
            break;
    }
    
    return fontSize;
}

+ (NSInteger)fontLevel{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ud_fontlevel"];
}

+ (void)setFontLevel:(NSInteger)level{
    
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"ud_fontlevel"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
