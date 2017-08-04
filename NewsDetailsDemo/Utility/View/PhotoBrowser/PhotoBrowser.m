//
//  PhotoBrowser.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "PhotoBrowser.h"

#import <Photos/Photos.h>

#import "HUD.h"

static UIWindow *browserWindow;

static NSString *photoAssetCollectionName = @"LEE";

@interface PhotoBrowser ()

@end

@implementation PhotoBrowser

- (void)dealloc{
    
    _imageUrlArray = nil;
}

+ (PhotoBrowser *)browser{
    
    return [[PhotoBrowser alloc] init];;
}

#pragma mark - 获取图片Url数组

- (void)setImageUrlArray:(NSArray *)imageUrlArray{
    
    if (imageUrlArray && imageUrlArray.count) {
        
        //处理Url对象类型
        
        NSMutableArray *tempImageUrlArray = [NSMutableArray array];
        
        for (id url in imageUrlArray) {
            
            if ([url isKindOfClass:[NSString class]]) {
                
                [tempImageUrlArray addObject:[NSURL URLWithString:url]];
                
            } else if ([url isKindOfClass:[NSURL class]]) {
                
                [tempImageUrlArray addObject:url];
                
            } else {
                
                NSLog(@"图片Url对象类型错误 应为NSUrl或NSString. [当前类型: %@]" , NSStringFromClass([url class]));
            }
            
        }
        
        if (imageUrlArray.count == tempImageUrlArray.count) {
            
            _imageUrlArray = tempImageUrlArray;
        }
        
    }
    
}

- (void)saveImageWithIndex:(NSInteger)index{
    
    if (browserWindow && browserWindow.rootViewController) {
        
        PhotoBrowserViewController *vc = (PhotoBrowserViewController *)browserWindow.rootViewController;
        
        [vc saveImageWithIndex:index];
    }
    
}

- (void)show{
    
    if (!_imageUrlArray.count) return;
    
    if (!browserWindow) browserWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PhotoBrowserViewController *vc = [[PhotoBrowserViewController alloc] init];
    
    vc.browser = self;
    
    browserWindow.rootViewController = vc;
    
    browserWindow.hidden = NO;
    
    [browserWindow makeKeyAndVisible];
    
    [vc show];
}

@end

@interface PhotoBrowserViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong ) UICollectionView *collectionView; //集合视图

@property (nonatomic , strong ) UICollectionViewFlowLayout *flowLayout; //布局

@property (nonatomic , strong ) UIView *topView; //顶部视图

@property (nonatomic , strong ) UIView *bottomView; //底部视图

@property (nonatomic , strong ) UILabel *pageLable; //页码

@property (nonatomic , strong ) UIButton *saveButton; //保存按钮

@property (nonatomic , strong ) UIImageView *tempImageView; //临时视图

@property (nonatomic , assign ) NSInteger currentIndex; //当前下标

@end

@implementation PhotoBrowserViewController

- (void)dealloc{
    
    _collectionView = nil;
    
    _flowLayout = nil;
    
    _pageLable = nil;
    
    _saveButton = nil;
    
    _tempImageView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // 初始化数据
    
    [self initData];
    
    // 初始化视图
    
    [self initSubView];
    
    // 设置自动布局
    
    [self configAutoLayout];
    
    // 设置主题模式
    
    [self configTheme];
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [_flowLayout invalidateLayout];
    
    _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 20.0f);
    
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80);
    
    if ([_bottomView.layer.sublayers.firstObject isKindOfClass:CAGradientLayer.class]) _bottomView.layer.sublayers.firstObject.frame = _bottomView.bounds;
    
    _pageLable.frame = CGRectMake(0, 30, self.view.frame.size.width, 20);
    
    _saveButton.frame = CGRectMake(self.view.frame.size.width - 60.0f, 20.0f, 40.0f, 40.0f);
}

#pragma mark - 初始化数据

- (void)initData{
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
}

#pragma mark - 初始化子视图

- (void)initSubView{
    
    // 初始化flowLayout
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置单元格的左右最小间距
    
    _flowLayout.minimumInteritemSpacing = 0;
    
    // 设置单元格的上下最小间距
    
    _flowLayout.minimumLineSpacing = 0;
    
    // 设置滑动方向
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置边界
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 初始化集合视图
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
    
    _collectionView.hidden = YES;
    
    _collectionView.pagingEnabled = YES;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:@"CELL"];
    
    [self.view addSubview:_collectionView];
    
    // 初始化顶部视图
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0f)];
    
    [self.view addSubview:_topView];
    
    // 初始化底部视图
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80)];
    
    [_bottomView.layer addSublayer:[self shadowAsInverseWithSize:CGSizeMake(self.view.frame.size.width, 80)]];
    
    [self.view addSubview:_bottomView];
    
    // 初始化页码Label
    
    _pageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 20)];
    
    _pageLable.textColor = [UIColor whiteColor];
    
    _pageLable.font = [UIFont systemFontOfSize:16.0f];
    
    _pageLable.textAlignment = NSTextAlignmentCenter;
    
    [self.bottomView addSubview:_pageLable];
    
    //初始化保存按钮
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _saveButton.hidden = YES;
    
    _saveButton.frame = CGRectMake(self.view.frame.size.width - 60.0f, 20.0f, 40.0f, 40.0f);
    
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_saveButton addTarget:self action:@selector(saveImageAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView addSubview:_saveButton];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
}

#pragma mark - 显示

- (void)show{
    
    // 非空验证
    
    if (!self.browser.imageUrlArray) return;
    
    if (self.browser.index >= self.browser.imageUrlArray.count) return;
    
    //设置当前下标与页数
    
    self.currentIndex = self.browser.index;
    
    self.pageLable.text = [NSString stringWithFormat:@"%ld/%ld",self.browser.index + 1,(unsigned long)self.browser.imageUrlArray.count];
    
    //添加到window上 并根据图片视图属性显示动画
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (self.browser.imageView) {
        
        CGRect currentRect = [self.browser.imageView convertRect: self.browser.imageView.bounds toView:window];
        
        UIGraphicsBeginImageContext(self.browser.imageView.frame.size);
        
        [self.browser.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.tempImageView = [[UIImageView alloc] initWithImage:image];
        
        self.tempImageView.frame = currentRect;
        
        [self.view addSubview:self.tempImageView];
        
        [UIView animateWithDuration:0.2f animations:^{
            
            CGRect tempImageViewFrame = self.tempImageView.frame;
            
            tempImageViewFrame.size.width = self.view.frame.size.width;
            
            tempImageViewFrame.size.height = self.view.frame.size.width * (currentRect.size.height / currentRect.size.width);
            
            tempImageViewFrame.origin.x = 0;
            
            tempImageViewFrame.origin.y = (self.view.frame.size.height - tempImageViewFrame.size.height) * 0.5f;
            
            self.tempImageView.frame = tempImageViewFrame;
            
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
            
        } completion:^(BOOL finished) {
            
            self.tempImageView.hidden = YES;
            
            self.collectionView.hidden = NO;
            
            [self.collectionView reloadData];
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }];
        
    } else {
        
        self.view.alpha = 0.0f;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.view.alpha = 1.0f;
            
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
        }];
        
        self.collectionView.hidden = NO;
        
        [self.collectionView reloadData];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

#pragma mark - 隐藏

- (void)hide{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (self.browser.imageView && self.currentIndex == self.browser.index) {
        
        CGRect currentRect = [self.browser.imageView convertRect: self.browser.imageView.bounds toView:window];
        
        self.tempImageView.hidden = NO;
        
        self.collectionView.hidden = YES;
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.tempImageView.frame = currentRect;
            
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
        } completion:^(BOOL finished) {
            
            [self.tempImageView removeFromSuperview];
            
            browserWindow.rootViewController = nil;
            
            browserWindow.hidden = YES;
            
            [browserWindow resignKeyWindow];
        }];
        
    } else {
        
        [UIView animateWithDuration:0.2f animations:^{
            
            self.view.alpha = 0.0f;
            
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
        } completion:^(BOOL finished) {
            
            browserWindow.rootViewController = nil;
            
            browserWindow.hidden = YES;
            
            [browserWindow resignKeyWindow];
        }];
        
    }
    
}

#pragma mark - 保存图片事件

- (void)saveImageAction{
    
    [self saveImageWithIndex:self.currentIndex];
}

#pragma mark - 保存图片

- (void)saveImageWithIndex:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    
    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    
    // 判断授权状态
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
            
        case PHAuthorizationStatusAuthorized:
            
            // 可以访问
            
            break;
            
        case PHAuthorizationStatusNotDetermined:
        {
            // 第一次访问
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    // 允许
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (weakSelf) [weakSelf saveImageWithIndex:index];
                    });
                    
                } else {
                    
                    return ;
                }
                
            }];
            
            return;
        }
            break;
            
        default:
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) [[UIApplication sharedApplication] openURL:url];
            
            return;
        }
            break;
    }
    
    // 获取当前图片的URL
    
    NSURL *url = [self.browser.imageUrlArray objectAtIndex:index];
    
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    
    if ([manager.cache containsImageForKey:[manager cacheKeyForURL:url]]) {
        
        // 获取图片
        
        NSData *data = [manager.cache getImageDataForKey:[manager cacheKeyForURL:url]];
        
        __block NSString *assetLocalIdentifier;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            // 1.保存图片到相机胶卷中----创建图片的请求
            
            if ([PHAssetCreationRequest class]) {
                
                PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                
                [request addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
                
                assetLocalIdentifier = request.placeholderForCreatedAsset.localIdentifier;
                
            } else {
                
                // iOS9以下
                
                NSString *tempCachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempSaveImage"];
                
                [data writeToFile:tempCachePath atomically:YES];
                
                PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:[NSURL fileURLWithPath:tempCachePath]];
                
                assetLocalIdentifier = request.placeholderForCreatedAsset.localIdentifier;
                
                [[NSFileManager defaultManager] removeItemAtPath:tempCachePath error:nil];
            }
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if(success == NO){
                
                NSLog(@"保存图片失败----(创建图片的请求)");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (weakSelf) [weakSelf.view showMessage:@"保存失败"];
                });
                
                return ;
            }
            
            // 2.获得相簿
            
            PHAssetCollection *createdAssetCollection = [self createAssetCollection];
            
            if (createdAssetCollection == nil) {
                
                NSLog(@"保存图片成功----(创建相簿失败!)");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (weakSelf) [weakSelf.view showMessage:@"保存成功"];
                });
                
                return;
            }
            
            // 3.将刚刚添加到"相机胶卷"中的图片到"自己创建相簿"中
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                // 获得图片
                
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
                
                // 添加图片到相簿中的请求
                
                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
                
                // 添加图片到相簿
                
                [request addAssets:@[asset]];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if(success){
                    
                    NSLog(@"保存图片到创建的相簿成功");
                    
                } else {
                    
                    NSLog(@"保存图片到创建的相簿失败");
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (weakSelf) [weakSelf.view showMessage:@"保存成功"];
                });
                
            }];
            
        }];
        
    } else {
        
        [self.view showMessage:@"保存图片失败"];
    }
    
}

#pragma mark - 获得相簿

- (PHAssetCollection *)createAssetCollection{
    
    // 判断是否已存在
    
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection * assetCollection in assetCollections) {
        
        if ([assetCollection.localizedTitle isEqualToString:photoAssetCollectionName]) {
            
            //说明已经存在
            
            return assetCollection;
        }
    }
    
    // 创建新的相簿
    
    __block NSString *assetCollectionLocalIdentifier = nil;
    
    NSError *error = nil;
    
    //同步方法
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        // 创建相簿的请求
        
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:photoAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:&error];
    
    if (error)return nil;
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

#pragma mark - 图片保存回调方法

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSString *msg = nil ;
    
    if (error){
        
        msg = @"保存图片失败";
        
    } else {
        
        msg = @"已成功存入相册";
    }
    
    [self.view showMessage:msg];
}

#pragma mark - 阴影处理

- (CAGradientLayer *)shadowAsInverseWithSize:(CGSize)size{
    
    long top = strtoul([@"00" UTF8String], 0, 16);
    long bot = strtoul([@"dd" UTF8String], 0, 16);
    
    UIColor *topColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:top / 255.0f];
    UIColor *botColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:bot / 255.0f];
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0, 0, size.width, size.height);
    layer.frame = newShadowFrame;
    
    // 添加渐变的颜色组合
    layer.colors = [NSArray arrayWithObjects:(id)topColor.CGColor,(id)botColor.CGColor, nil];
    
    return layer;
}

#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.browser.imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    cell.longClickBlock = ^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.browser.longClickBlock) weakSelf.browser.longClickBlock(weakSelf.browser , weakSelf.currentIndex);
    };
    
    cell.loadFinishBlock = ^(NSURL *url , UIImage *image){
        
        if (weakSelf) {
            
            // 判断是否为当前显示的图片 如果是则显示保存按钮
            
            if (weakSelf.currentIndex == [weakSelf.browser.imageUrlArray indexOfObject:url]) {
                
                weakSelf.saveButton.hidden = NO;
            }
            
            // 回调加载完成的下标
            
            if (weakSelf.browser.loadFinishBlock) weakSelf.browser.loadFinishBlock(weakSelf.browser , [weakSelf.browser.imageUrlArray indexOfObject:url]);
        }
        
    };
    
    cell.hideBlock = ^(){
        
        if (weakSelf) {
            
            [weakSelf hide];
        }
        
    };
    
    cell.url = self.browser.imageUrlArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 设置当前页数与下标
    
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    self.pageLable.text = [NSString stringWithFormat:@"%ld/%ld",page + 1,(unsigned long)self.browser.imageUrlArray.count];
    
    self.currentIndex = page;
    
    // 获取当前图片的URL 并查询缓存 显示隐藏保存按钮
    
    id url = [self.browser.imageUrlArray objectAtIndex:self.currentIndex];
    
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    
    if ([manager.cache containsImageForKey:[manager cacheKeyForURL:url]]) {
        
        self.saveButton.hidden = NO;
        
    } else {
        
        self.saveButton.hidden = YES;
    }
    
}

@end

@interface PhotoBrowserCell ()<MBProgressHUDDelegate , UIScrollViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic , strong ) UIScrollView *scrollView; //滑动视图

@property (nonatomic , strong ) YYAnimatedImageView *imageView; //图片视图

@property (nonatomic , strong ) UIButton *promptButton; //提示

@property (nonatomic , strong ) MBProgressHUD *HUD; //HUD提示框

@property (nonatomic , strong ) MBRoundProgressView *roundProgressView; //进度条视图

@end

@implementation PhotoBrowserCell

- (void)dealloc{
    
    _url = nil;
    
    _loadFinishBlock = nil;
    
    _hideBlock = nil;
    
    _scrollView = nil;
    
    _imageView = nil;
    
    _promptButton = nil;
    
    _HUD = nil;
    
    _roundProgressView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        // 初始化滑动视图
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        _scrollView.maximumZoomScale = 5.0f;
        
        _scrollView.minimumZoomScale = 0.3f;
        
        _scrollView.zoomScale = 1.0f;
        
        _scrollView.delegate = self;
        
        [self.contentView addSubview:_scrollView];
        
        // 初始化单击手势
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [self.contentView addGestureRecognizer:tap];
        
        // 初始化图片视图
        
        _imageView = [[YYAnimatedImageView alloc] init];
        
        _imageView.userInteractionEnabled = YES;
        
        _imageView.autoPlayAnimatedImage = YES;
        
        [self.scrollView addSubview:_imageView];
        
        // 初始化图片点击手势
        
        UITapGestureRecognizer *imageDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        
        imageDoubleTap.numberOfTapsRequired = 2;
        
        imageDoubleTap.numberOfTouchesRequired = 1;
        
        imageDoubleTap.delegate = self;
        
        [self.imageView addGestureRecognizer:imageDoubleTap];
        
        UILongPressGestureRecognizer *imageLong = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongAction:)];
        
        imageLong.allowableMovement = 20.0f;
        
        imageLong.minimumPressDuration = 0.8f;
        
        imageLong.numberOfTouchesRequired = 1;
        
        imageLong.delegate = self;
        
        [self.imageView addGestureRecognizer:imageLong];
        
        [tap requireGestureRecognizerToFail:imageLong];
        
        // 当没有检测到图片双击手势时 或者 检测图片双击手势失败，单击手势才有效
        
        [tap requireGestureRecognizerToFail:imageDoubleTap];
        
        // 初始化提示Label
        
        _promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _promptButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame) * 0.5f);
        
        _promptButton.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5f, CGRectGetHeight(self.frame) * 0.5f);
        
        _promptButton.hidden = YES;
        
        [_promptButton setTitle:@"加载失败 点击重试" forState:UIControlStateNormal];
        
        [_promptButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        _promptButton.backgroundColor = [UIColor darkGrayColor];
        
        [_promptButton addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_promptButton];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    _scrollView.zoomScale = 1;
    
    _promptButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame) * 0.5f);
    
    _promptButton.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5f, CGRectGetHeight(self.frame) * 0.5f);
    
    [self configImageViewLayout];
}

#pragma mark - 获取图片Url

- (void)setUrl:(NSURL *)url{
    
    _url = url;
    
    if (_url) [self loadImage];
}

#pragma mark - 加载图片

- (void)loadImage{
    
    // 缩放比例
    
    self.scrollView.zoomScale = 1;
    
    // 进度条归0
    
    [self.roundProgressView setProgress:0.0f];
    
    // 显示提示框
    
    [self.HUD show:YES];
    
    // 隐藏提示Label
    
    self.promptButton.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [self.imageView setImageWithURL:self.url placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        if (!weakSelf) return ;
        
        // 计算加载进度百分比 并设置进度条
        
        float progressFloat = (float)receivedSize/(float)expectedSize;
        
        [weakSelf.HUD show:NO];
        
        [weakSelf.roundProgressView setProgress:progressFloat];
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        return image;
        
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return ;
        
        // 隐藏提示框
        
        [strongSelf.HUD hide:NO];
        
        switch (stage) {
            case YYWebImageStageFinished:
            {
                if (!error && image) {
                    
                    strongSelf.promptButton.hidden = YES;
                    
                    // 设置图片视图布局
                    
                    [strongSelf configImageViewLayout];
                    
                    // 调用加载完成回调Block
                    
                    if (strongSelf.loadFinishBlock) strongSelf.loadFinishBlock(url , image);
                    
                } else {
                    
                    strongSelf.promptButton.hidden = NO;
                }
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

#pragma mark - 设置图片视图布局

- (void)configImageViewLayout{
    
    // 获取图片宽高 并设置大小
    
    UIImage *image = self.imageView.image;
    
    CGFloat width =  image.size.width;
    
    CGFloat height = image.size.height;
    
    CGFloat ratio = height ? (width / height) : 0;
    
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    
    CGFloat scrollViewHeight = self.scrollView.frame.size.height;
    
    if (scrollViewWidth > scrollViewHeight) {
        
        // 横屏
        
        self.imageView.frame = CGRectMake(0, 0, ratio ? scrollViewHeight * ratio : 0, scrollViewHeight);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
        
        if (self.imageView.frame.size.width > scrollViewWidth) {
            
            self.imageView.center = CGPointMake(CGRectGetWidth(self.imageView.frame) * 0.5f, scrollViewHeight * 0.5f);
            
        } else {
            
            self.imageView.center = CGPointMake(scrollViewWidth * 0.5f , scrollViewHeight * 0.5f);
        }
        
    } else {
        
        // 竖屏
        
        self.imageView.frame = CGRectMake(0, 0, scrollViewWidth, ratio ? scrollViewWidth / ratio : 0);
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
        
        if (self.imageView.frame.size.height > scrollViewHeight) {
            
            self.imageView.center = CGPointMake(scrollViewWidth * 0.5f, CGRectGetHeight(self.imageView.frame) * 0.5f);
            
        } else {
            
            self.imageView.center = CGPointMake(scrollViewWidth * 0.5f , scrollViewHeight * 0.5f);
        }
        
    }
    
}

#pragma mark - 单击事件

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (self.hideBlock) self.hideBlock();
}

#pragma mark - 图片双击事件

- (void)imageTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.scrollView.zoomScale == 1.0f) {
        
        [self.scrollView setZoomScale:1.5f animated:YES]; //1.5倍放大
        
    } else {
        
        [self.scrollView setZoomScale:1.0f animated:YES]; //还原缩放比例
    }
    
}

#pragma mark - 图片长按事件

- (void)imageLongAction:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan){
        
        if (self.imageView.image) {
            
            if (self.longClickBlock) self.longClickBlock(self.imageView.image);
        }
        
    }
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    // 当scrollView正在缩放的时候会频繁响应的方法
    
    // x和y轴的增量:
    
    // 当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    
    // 条件运算符
    
    CGFloat delta_x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    
    CGFloat delta_y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    
    // 让imageView一直居中
    
    // 实时修改imageView的center属性 保持其居中
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

#pragma mark - LazyLoading

- (MBProgressHUD *)HUD{
    
    if (!_HUD) {
        
        _HUD = [[MBProgressHUD alloc] initWithView:self.contentView];
        
        [self.contentView addSubview:_HUD];
        
        _HUD.mode = MBProgressHUDModeCustomView; //设置自定义视图模式
        
        _HUD.color = [UIColor clearColor];
        
        _HUD.customView = self.roundProgressView;
    }
    
    return _HUD;
}

- (MBRoundProgressView *)roundProgressView{
    
    if (!_roundProgressView) {
        
        _roundProgressView = [[MBRoundProgressView alloc]initWithFrame:CGRectMake(0, 0, 64 , 64)];
    }
    
    return _roundProgressView;
}
@end
