//
//  NewsDetailsHeaderView.m
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "NewsDetailsHeaderView.h"

#import <objc/message.h>

#import "SDAutoLayout.h"

#import "WebKitSupport.h"

#import "PhotoBrowser.h"

@interface NewsDetailsHeaderView ()<WKUIDelegate , WKNavigationDelegate , WKScriptMessageHandler>

@property (nonatomic , strong ) UIView *headerView; //头部视图

@property (nonatomic , strong ) UILabel *titleLabel; //标题

@property (nonatomic , strong ) UILabel *sourceLabel; //来源

@property (nonatomic , strong ) UILabel *timeLabel; //时间

@property (nonatomic , strong ) WKWebView *webView; //内容webview

@property (nonatomic , strong ) NSMutableArray *imageInfoArray; //图片信息数组

@property (nonatomic , strong ) WeakScriptMessageDelegate *scriptDelegate; // 脚本代理

@property (nonatomic , strong ) CADisplayLink *displayLink;

@end

static NSString *const ScriptName_clickImage = @"clickImage";
static NSString *const ScriptName_loadImage = @"loadImage";
static NSString *const ScriptName_loadGifImage = @"loadGifImage";

@implementation NewsDetailsHeaderView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_displayLink invalidate];
    
    _displayLink = nil;
    
    if (_webView) {
        
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptName_clickImage];
        
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptName_loadImage];
        
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptName_loadGifImage];
        
        [_webView stopLoading];
        
        _webView.navigationDelegate = nil;
        
        _webView.UIDelegate = nil;
        
        _webView = nil;
    }
    
    _scriptDelegate = nil;
    
    _imageInfoArray = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置通知
        
        [self configNotification];
        
        // 初始化数据
        
        [self initData];
        
        // 初始化子视图
        
        [self initSubview];
        
        // 设置自动布局
        
        [self configAutoLayout];
        
        // 设置主题模式
        
        [self configTheme];
    }
    return self;
}

#pragma mark - 设置通知

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 从后台回到前台

- (void)willEnterForegroundNotification:(NSNotification *)notify{
    
    if (!self.webView.title) [self.webView reload];
}

#pragma mark - 初始化数据

- (void)initData{
    
    [ContentManager initData];
    
    _scriptDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    
    _imageInfoArray = [NSMutableArray array];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(updateWebViewVisible)];
    
    _displayLink.paused = YES;
    
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    _loadMode = ContentImageLoadModeScroll;
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    // 头部视图
    
    _headerView = [[UIView alloc] init];
    
    [self addSubview:_headerView];
    
    // 标题
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:[ContentManager fontSize:22.0f]];
    
    _titleLabel.numberOfLines = 0;
    
    [self.headerView addSubview:_titleLabel];
    
    // 来源
    
    _sourceLabel = [[UILabel alloc] init];
    
    _sourceLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _sourceLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.headerView addSubview:_sourceLabel];
    
    // 时间
    
    _timeLabel = [[UILabel alloc] init];
    
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.headerView addSubview:_timeLabel];
    
    // webView
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    webConfig.preferences = [[WKPreferences alloc] init]; // 设置偏好设置
    
    webConfig.preferences.minimumFontSize = 10; // 默认为0
    
    webConfig.preferences.javaScriptEnabled = YES; // 默认认为YES
    
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO; // 在iOS上默认为NO，表示不能自动通过窗口打开
    
    webConfig.userContentController = [[WKUserContentController alloc] init]; // 通过JS与webview内容交互
    
    [webConfig.userContentController addScriptMessageHandler:self.scriptDelegate name:ScriptName_clickImage]; // 注入JS对象
    
    [webConfig.userContentController addScriptMessageHandler:self.scriptDelegate name:ScriptName_loadImage]; // 注入JS对象
    
    [webConfig.userContentController addScriptMessageHandler:self.scriptDelegate name:ScriptName_loadGifImage]; // 注入JS对象
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) configuration:webConfig];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.UIDelegate = self;
    
    _webView.navigationDelegate = self;
    
    _webView.scrollView.bounces = NO;
    
    _webView.scrollView.bouncesZoom = NO;
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.scrollView.directionalLockEnabled = YES;
    
    _webView.scrollView.scrollEnabled = NO;
    
    [self addSubview:_webView];
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    // 头部视图
    
    _headerView.sd_layout
    .topSpaceToView(self, 0.0f)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f);
    
    // 标题
    
    _titleLabel.sd_layout
    .topSpaceToView(self.headerView, 20.0f)
    .leftSpaceToView(self.headerView, 15.0f)
    .rightSpaceToView(self.headerView, 15.0f)
    .autoHeightRatio(0);
    
    // 来源
    
    _sourceLabel.sd_layout
    .leftSpaceToView(self.headerView, 15.0f)
    .topSpaceToView(self.titleLabel, 10.0f)
    .widthIs(150.0f)
    .heightIs(15.0f);
    
    // 时间
    
    _timeLabel.sd_layout
    .rightSpaceToView(self.headerView, 15.0f)
    .topSpaceToView(self.titleLabel, 10.0f)
    .widthIs(150.0f)
    .heightIs(15.0f);
    
    [self.headerView setupAutoHeightWithBottomView:self.timeLabel bottomMargin:10.0f];
    
    //webview
    
    _webView.sd_layout
    .topSpaceToView(self.headerView , 0.0f)
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f);
    
    //自适应高度
    
    [self setupAutoHeightWithBottomView:self.webView bottomMargin:0.0f];
    
    __weak typeof(self) weakSelf = self;
    
    [self setDidFinishAutoLayoutBlock:^(CGRect rect) {
        
        if (weakSelf) {
            
            if (weakSelf.updateHeightBlock) weakSelf.updateHeightBlock(weakSelf);
        }
        
    }];
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    self.titleLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_222222)
    .LeeAddTextColor(THEME_NIGHT, HEX_777777);
    
    self.sourceLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_666666);
    
    self.timeLabel.lee_theme
    .LeeAddTextColor(THEME_DAY, HEX_999999)
    .LeeAddTextColor(THEME_NIGHT, HEX_666666);
    
    self.webView.lee_theme
    .LeeAddBackgroundColor(THEME_DAY, HEX_FFFFFF)
    .LeeAddBackgroundColor(THEME_NIGHT, HEX_252525);
    
    // WebView适配日夜间切换操作
     
    __weak typeof(self) weakSelf = self;
    
    self.webView.lee_theme
    .LeeAddCustomConfig(THEME_DAY , ^(WKWebView *webView){
        
        if (!weakSelf) return ;
        
        if (webView.URL) {
            
            // 设置样式类型
            
            [webView evaluateJavaScript:@"configStyle('0');" completionHandler:^(id _Nullable response, NSError * _Nullable error) {}];
        }
        
    })
    .LeeAddCustomConfig(THEME_NIGHT , ^(WKWebView *webView){
        
        if (!weakSelf) return ;
            
        if (webView.URL) {
            
            // 设置样式类型
            
            [webView evaluateJavaScript:@"configStyle('1');" completionHandler:^(id _Nullable response, NSError * _Nullable error) {}];
        }
        
    });
    
}

- (void)setModel:(NewsDetailsModel *)model{
    
    _model = model;
    
    self.titleLabel.text = model.newsTitle;
    
    self.sourceLabel.text = @"LEE";
    
    self.timeLabel.text = model.newsTime;
    
    [self handleHTML:model.newsHtml];
}

#pragma mark - 处理HTML

- (void)handleHTML:(NSString *)htmlString{
    
    if (!htmlString) return;
    
    /**
     
     HTML处理流程
     
     - 正则过滤出所有img标签的字符串
     - 获取img标签的src值
     - 根据src查询原图缓存是否存在 如不存在则继续查询缩略图缓存
     - 如果缓存存在则直接将缓存路径设置到src 并将状态置为4 或 5 (Gif类型缩略图加载完成状态为5)
     - 如果缓存不存在则根据是否可以加载图片设置相应的状态.
     - 获取原img标签字符串中的宽高属性值 如果存在 则按照比例计算出新的宽高设置.
     - 黑白主题样式是通过标签的ClassName区分的 根据当前主题添加相应的ClassName (CSS中有定义).
     - 将以上处理组合成一个新的标签元素字符串 并替换html中原来img标签字符串.
     
     新标签格式如下:
     
     <div class="image white">
     <img class="image white" src="" data-thumbnail="" data-original=""  data-gif="0" data-state="0" data-index="0"/>
     <span class="load"></span>
     </div>
     */
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return ;
        
        NSString *styleType = [[LEETheme currentThemeTag] isEqualToString:THEME_DAY] ? @"white" : @"black";
        
        CGFloat maxWidth = (CGRectGetWidth([[UIScreen mainScreen] bounds]) < CGRectGetHeight([[UIScreen mainScreen] bounds]) ? CGRectGetWidth([[UIScreen mainScreen] bounds]) : CGRectGetHeight([[UIScreen mainScreen] bounds])) - 30.0f;
        
        
        NSMutableString *contentHTMLString = [[NSMutableString alloc] initWithString:htmlString];
        
        NSString *imgRegex = @"(<img.*?>) | (<img.*?></img>) "; //img标签正则表达式
        
        NSError *imgError;
        
        NSRegularExpression *imgRegular = [NSRegularExpression regularExpressionWithPattern:imgRegex
                                                                                    options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                                      error:&imgError];
        if (!imgError) {
            
            // 对字符串进行匹配
            
            NSArray *matches = [imgRegular matchesInString:htmlString
                                                   options:0
                                                     range:NSMakeRange(0, contentHTMLString.length)];
            
            // 遍历匹配后的每一条记录
            
            for (NSTextCheckingResult *match in matches) {
                
                NSString *imgHtml = [htmlString substringWithRange:[match rangeAtIndex:0]];
                
                NSString *src = [weakSelf getElementAttributeValueWithElement:imgHtml Attribute:@"src"];
                
                NSString *width = [weakSelf getElementAttributeValueWithElement:imgHtml Attribute:@"width"];
                
                NSString *height = [weakSelf getElementAttributeValueWithElement:imgHtml Attribute:@"height"];
                
                if (src) {
                    
                    ContentImageLoadState state = 0;
                    
                    BOOL gif = [src hasSuffix:@".gif"];
                    
                    // 获取缩略图Url
                    
                    NSString *thumbnail = [src stringByAppendingFormat:@"?x-oss-process=image/format,jpg/resize,w_%.0f" , maxWidth];
                    
                    // 获取原图Url
                    
                    NSString *original = src;
                    
                    // 查询原图缓存
                    
                    NSString *originalPath = [ContentManager getCacheImageFilePathWithUrl:original];
                    
                    // 查询缩略图缓存
                    
                    NSString *thumbnailPath = [ContentManager getCacheImageFilePathWithUrl:thumbnail];
                    
                    // 组装新标签
                    
                    NSMutableString *imageString = [[NSMutableString alloc] init];
                    
                    [imageString appendFormat:@"<div class=\"image %@\">" , styleType];
                    
                    [imageString appendFormat:@"<img class=\"image %@\"" , styleType];
                    
                    if (originalPath) {
                        
                        // 设置缓存图片路径
                        
                        [imageString appendFormat:@" src=\"%@\"" , [NSURL fileURLWithPath:originalPath].absoluteString];
                        
                        // 设置状态
                        
                        state = 4;
                        
                    } else if (thumbnailPath) {
                        
                        // 设置缓存图片路径
                        
                        [imageString appendFormat:@" src=\"%@\"" , [NSURL fileURLWithPath:thumbnailPath].absoluteString];
                        
                        // 设置状态
                        
                        state = gif ? ContentImageLoadStateGif : ContentImageLoadStateFinish;
                        
                    } else {
                        
                        // 设置缓存图片路径
                        
                        [imageString appendFormat:@" src=\"../defaultimage/load_image.png\""];
                        
                        // 设置状态
                        
                        state = [ContentManager isLoadImage] ? ContentImageLoadStateInitial : ContentImageLoadStateClick;
                    }
                    
                    [imageString appendFormat:@" data-gif=\"%d\"" , gif];
                    
                    [imageString appendFormat:@" data-thumbnail=\"%@\"" , thumbnail];
                    
                    [imageString appendFormat:@" data-original=\"%@\"" , original];
                    
                    [imageString appendFormat:@" data-state=\"%ld\"" , (long)state];
                    
                    if (width && height) {
                        
                        CGFloat w = [width floatValue];
                        
                        CGFloat h = [height floatValue];
                        
                        CGFloat ratio = h / w;
                        
                        [imageString appendFormat:@" width=\"%.0f\"" , maxWidth];
                        
                        [imageString appendFormat:@" height=\"%.0f\"" , ratio * maxWidth];
                        
                    } else {
                        
                        [imageString appendFormat:@" width=\"%.0f\"" , maxWidth];
                        
                        [imageString appendFormat:@" height=\"auto\""];
                    }
                    
                    [imageString appendString:@"/>"];
                    
                    [imageString appendFormat:@"<span class=\"load\"></span>"];
                    
                    [imageString appendString:@"</div>"];
                    
                    // 原img标签字符串
                    
                    NSString *imgString = [htmlString substringWithRange:[match range]];
                    
                    // 替换原有标签
                    
                    [contentHTMLString replaceCharactersInRange:[contentHTMLString rangeOfString:imgString] withString:imageString];
                }
                
            }
            
        }
        
        NSString *fontSize = [NSString stringWithFormat:@"%.0f" , [ContentManager fontSize:16.0f + [ContentManager fontLevel] * 2]];
        
        NSString *frame = [NSString stringWithFormat:@"\
                           <html class=\"%@\">\
                           <head>\
                           <meta http-equiv =\"Content-Type\" content=\"text/html; charset=utf-8\"/>\
                           <meta name = \"viewport\" content=\"width = device-width, initial-scale = 1, user-scalable=no\"/>\
                           <title></title>\
                           <link href=\"../css/WebContentStyle.css\" rel=\"stylesheet\" type=\"text/css\"/>\
                           <script src=\"../js/jquery.min.js\"></script>\
                           <script src=\"../js/radialIndicator.js\"></script>\
                           </head>\
                           <body style=\"font-size:%@px;\">\
                           <div class=\"content\">%@</div>\
                           </body>\
                           <script src=\"../js/WebContentHandle.js\"></script>\
                           </html>" , styleType , fontSize , contentHTMLString];
        
        NSString *htmlPath = [[ContentManager getCachePath:@"html"] stringByAppendingPathComponent:@"newsContent.html"];
        
        NSURL *htmlUrl = [NSURL fileURLWithPath:htmlPath];
        
        NSError *error = nil;
        
        [frame writeToURL:htmlUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) [strongSelf.webView loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
        });
        
    });
    
}

#pragma mark - 获取HTML元素属性值

- (NSString *)getElementAttributeValueWithElement:(NSString *)element Attribute:(NSString *)attribute{
    
    NSString *value = nil;
 
    if (element && element.length && attribute && attribute.length) {
     
        // 去除空格
        
        element = [element stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSArray *array = nil;
        
        if ([element rangeOfString:[NSString stringWithFormat:@"%@=\"" , attribute]].location != NSNotFound) {
            
            array = [element componentsSeparatedByString:[NSString stringWithFormat:@"%@=\"" , attribute]];
            
        } else if ([element rangeOfString:[NSString stringWithFormat:@"%@=" , attribute]].location != NSNotFound) {
            
            array = [element componentsSeparatedByString:[NSString stringWithFormat:@"%@=" , attribute]];
        }
        
        if (array.count >= 2) {
            
            NSString *temp = array[1];
            
            NSUInteger loc = [temp rangeOfString:@"\""].location;
            
            if (loc != NSNotFound) {
                
                temp = [temp substringToIndex:loc];
                
                if (temp.length > 0) value = temp;
            }
            
        }
        
    }
    
    return value;
}

#pragma mark - 加载图片

- (void)loadImages{
    
    if (![ContentManager isLoadImage]) return;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < self.imageInfoArray.count ; i++) {
        
        dispatch_group_enter(group);
        
        [self loadImage:i ResultBlock:^{
            
            dispatch_group_leave(group);
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (!weakSelf) return ;
        
        [weakSelf updateHeight];
    });
}

#pragma mark - 加载图片

- (void)loadImage:(NSInteger)index ResultBlock:(void (^)())resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    if (self.imageInfoArray.count == 0 && self.imageInfoArray.count <= index) return;
    
    NSString *url = nil;
    
    NSDictionary *info = self.imageInfoArray[index];
    
    BOOL gif = [info[@"gif"] boolValue];
    
    // 获取当前Url (src)
    
    NSString *current = info[@"current"];
    
    // 获取缩略图Url
    
    NSString *thumbnail = info[@"thumbnail"];
    
    // 获取原图Url
    
    NSString *original = info[@"original"];
    
    // 判断缓存是否存在
    
    NSString *originalPath = [ContentManager getCacheImageFilePathWithUrl:original];
    
    if (originalPath) {
        
        // 原图存在 当前不等于原图 重新设置
        
        if (![current isEqualToString:[NSURL fileURLWithPath:originalPath].absoluteString]) {
            
            [weakSelf loadImageFinishHandleWithIndex:index State:ContentImageLoadStateFinish ImagePath:originalPath ResultBlock:resultBlock];
            
        } else {
            
            if (resultBlock) resultBlock();
        }
        
    } else {
        
        NSString *thumbnailPath = [ContentManager getCacheImageFilePathWithUrl:thumbnail];
        
        if (thumbnailPath) {
            
            // 缩略图存在 当前不等于缩略图 重新设置
            
            if (![current isEqualToString:[NSURL fileURLWithPath:thumbnailPath].absoluteString]) {
                
                [weakSelf loadImageFinishHandleWithIndex:index State:gif ? ContentImageLoadStateGif : ContentImageLoadStateFinish ImagePath:thumbnailPath ResultBlock:resultBlock];
            
            } else {
                
                if (resultBlock) resultBlock();
            }
            
        } else {
            
            // 都不存在
            
            url = thumbnail;
        }
        
    }
    
    if (!url) return;
    
    // 设置加载中状态
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"configImgState('1' , '%ld');" , (long)index] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        if (!weakSelf) return;
        
        // 加载图片
        
        [ContentManager loadImage:[NSURL URLWithString:url] ResultBlock:^(NSString *cachePath, BOOL result) {
            
            if (!weakSelf) return;
            
            // 判断结果 并设置相应的状态
            
            if (result) {
                
                // 设置图片Url和完成状态
                
                // 获取状态 如果是gif图加载完成 则设置5
                
                [weakSelf loadImageFinishHandleWithIndex:index State:gif ? ContentImageLoadStateGif : ContentImageLoadStateFinish ImagePath:cachePath ResultBlock:resultBlock];
                
            } else {
                
                // 设置加载失败状态
                
                NSString *configJS = [NSString stringWithFormat:@"configImgState('3' , '%ld');" , (long)index];
                
                [weakSelf.webView evaluateJavaScript:configJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                    
                    if (resultBlock) resultBlock();
                }];
                
            }
            
        }];
        
    }];
    
}

- (void)loadGifImage:(NSInteger)index ResultBlock:(void (^)())resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    if (self.imageInfoArray.count == 0 && self.imageInfoArray.count <= index) return;
    
    NSDictionary *info = self.imageInfoArray[index];
    
    // 获取当前Url (src)
    
    NSString *current = info[@"current"];
    
    // 获取原图Url
    
    NSString *original = info[@"original"];
    
    // 判断缓存是否存在
    
    NSString *originalPath = [ContentManager getCacheImageFilePathWithUrl:original];
    
    if (originalPath) {
        
        // 原图存在 当前不等于原图 重新设置
        
        if (![current isEqualToString:[NSURL fileURLWithPath:originalPath].absoluteString]) {
            
            [weakSelf loadImageFinishHandleWithIndex:index State:ContentImageLoadStateFinish ImagePath:originalPath ResultBlock:resultBlock];
            
        } else {
            
            if (resultBlock) resultBlock();
        }
        
    } else {
        
        // 加载图片 进度置为0 清空原有进度视图 进度置为1 创建进度视图
        
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"configLoadingProgress('%ld' , '0'); configLoadingProgress('%ld' , '1');" , (long)index, (long)index] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
            if (!weakSelf) return ;
           
            __block CGFloat currentProgress = 0.0f;
            
            [ContentManager loadImage:[NSURL URLWithString:original] ProgressBlock:^(CGFloat progress) {
                
                if (!weakSelf) return ;
                
                progress = progress * 100;
                
                // 限制更新频率 每次超过10% 更新一次
                
                if ((progress - currentProgress >= 10 && currentProgress != progress) ||
                    progress == 0 ||
                    progress == 100) {
                    
                    [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"configLoadingProgress('%ld' , '%.0f');" , (long)index, progress ? : 1.0f] completionHandler:^(id _Nullable response, NSError * _Nullable error) {}];
                    
                    currentProgress = progress;
                }
                
            } ResultBlock:^(NSString *cachePath, BOOL result) {
                
                if (!weakSelf) return;
                
                // 判断结果 并设置相应的状态
                
                if (result) {
                    
                    // 设置图片Url和完成状态
                    
                    [weakSelf loadImageFinishHandleWithIndex:index State:ContentImageLoadStateFinish ImagePath:cachePath ResultBlock:resultBlock];
                    
                } else {
                    
                    // 设置加载失败状态 (gif图片失败 则重新设置为5)
                    
                    NSString *configJS = [NSString stringWithFormat:@"configImgState('5' , '%ld');" , (long)index];
                    
                    [weakSelf.webView evaluateJavaScript:configJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {}];
                }
                
            }];
            
        }];
        
    }
    
}

- (void)loadImageFinishHandleWithIndex:(NSInteger)index State:(ContentImageLoadState)state ImagePath:(NSString *)imagepath ResultBlock:(void (^)())resultBlock{
    
    __weak typeof(self) weakSelf = self;
    
    // 设置图片Url和完成状态
    
    NSString *js = [NSString stringWithFormat:@"setImageUrl('%ld' , '%@'); configImgState('%ld' , '%ld'); getImageInfo('%ld');" , (long)index , [NSURL fileURLWithPath:imagepath].absoluteString , (long)state , (long)index , (long)index];
    
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        if (!weakSelf) return;
        
        // 更新图片信息
        
        if (response) [weakSelf.imageInfoArray replaceObjectAtIndex:index withObject:response];
        
        // 更新webview高度
        
        [weakSelf updateHeight];
        
        if (resultBlock) resultBlock();
    }];
    
}

- (void)updateWebViewVisible{
    
    // 刷新内容 (解决某些没有刷新的WKCompositingView)
    
    if ([self.webView respondsToSelector:@selector(_updateVisibleContentRects)]) {
        
        ((void(*)(id,SEL,BOOL))objc_msgSend)(self.webView, @selector(_updateVisibleContentRects),NO);
    }
}

#pragma mark - 设置字体等级

- (void)configFontLevel:(NSInteger)level{
    
    [ContentManager setFontLevel:level];
    
    NSInteger fontSize = [ContentManager fontSize:16.0f + level * 2];
    
    NSString *js = [NSString stringWithFormat:@"configFontSize('%ld');" , (long)fontSize];
    
    //设置字体大小
    
    __weak typeof(self) weakSelf = self;
    
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        //更新webview高度
        
        if (weakSelf) [weakSelf updateHeight];
    }];
    
}

#pragma mark - 更新高度

- (void)updateHeight{
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!weakSelf) return ;
        
        [weakSelf.webView evaluateJavaScript:@"getContentHeight();" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
            if (!weakSelf) return ;
            
            if (!error) {
                
                CGFloat height = [response floatValue];
                
                if (weakSelf.webView.height != height) {
                    
                    weakSelf.webView.sd_layout.heightIs(height);
                    
                    [weakSelf updateLayout];
                }
                
            }
            
        }];
        
    });
    
}

- (void)scroll:(CGPoint)offset{
    
    // 判断图片加载模式
    
    if (self.loadMode == ContentImageLoadModeScroll) {
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!weakSelf) return ;
            
            // 判断webview是否在可视范围
            
            if (offset.y >= weakSelf.webView.top && offset.y <= weakSelf.webView.bottom) {
                
                // 获取top距离 和 可视高度
                
                CGFloat top = offset.y > weakSelf.webView.top ? offset.y - weakSelf.webView.top : 0.0f;
                
                CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds]) - 64.0f;
                
                [weakSelf.webView evaluateJavaScript:[NSString stringWithFormat:@"scroll(%.0f , %.0f);" , top , height] completionHandler:^(id _Nullable response, NSError * _Nullable error) {}];
            }
            
        });
        
    }
    
}

#pragma mark - 打开图片浏览

- (void)openPhotoBrowserWithUrlArray:(NSArray *)urlArray Index:(NSInteger)index{
    
    PhotoBrowser *browser = [PhotoBrowser browser];
    
    browser.imageUrlArray = urlArray;
    
    browser.index = index;
    
    [browser show];
    
    __weak typeof(self) weakSelf = self;
    
    browser.loadFinishBlock = ^(PhotoBrowser *weakBrowser, NSInteger index) {
        
        if (!weakSelf) return ;
        
        // 更新webview中的图片
        
        [weakSelf loadImage:index ResultBlock:^{}];
    };
    
    browser.longClickBlock = ^(PhotoBrowser *weakBrowser, NSInteger index) {
        
        if (!weakSelf) return ;
        
        // 打开actionsheet
        
        [LEEAlert actionsheet].config
        .LeeDestructiveAction(@"保存", ^{
            
            [weakBrowser saveImageWithIndex:index];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            
            action.title = @"取消";
            
            action.titleColor = [UIColor blackColor];
            
            action.font = [UIFont systemFontOfSize:18.0f];
        })
        .LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]) // 设置取消按钮间隔的颜色
        .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
        .LeeActionSheetBackgroundColor([UIColor whiteColor])
        .LeeCornerRadius(0.0f) // 设置圆角曲率为0
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
            
            // 这是最大宽度为屏幕宽度 (横屏和竖屏)
            
            return CGRectGetWidth([[UIScreen mainScreen] bounds]);
        })
        .LeeBackgroundStyleBlur(UIBlurEffectStyleDark)
        .LeeShow();
    };
}

#pragma mark - WKUIDelegate

// 创建新的webview
// 可以指定配置对象、导航动作对象、window特性
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    // 创建一个新的WebView（标签带有 target='_blank' 时，导致WKWebView无法加载点击后的网页的问题。）
    // 接口的作用是打开新窗口委托
    
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    
    if (![frameInfo isMainFrame]) {
        
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

// webview关闭时回调
- (void)webViewDidClose:(WKWebView *)webView{
    
}

// 调用JS的alert()方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    [LEEAlert alert].config
    .LeeTitle(message)
    .LeeAction(@"好的", ^{
        
        completionHandler();
    })
    .LeeShow();
}

// 调用JS的confirm()方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    [LEEAlert alert].config
    .LeeTitle(message)
    .LeeAction(@"确认", ^{
        
        completionHandler(YES);
    })
    .LeeCancelAction(@"取消", ^{
        
        completionHandler(NO);
    })
    .LeeShow();
}

// 调用JS的prompt()方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    __block UITextField *tf = nil;
    
    [LEEAlert alert].config
    .LeeTitle(prompt)
    .LeeAddTextField(^(UITextField *textField) {
        
        textField.text = defaultText;
        
        tf = textField;
    })
    .LeeAction(@"确认", ^{
        
        completionHandler(tf.text);
    })
    .LeeCancelAction(@"取消", ^{
        
        completionHandler(@"");
    })
    .LeeShow();
}

#pragma mark - WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    WKFrameInfo *targetFrameInfo = navigationAction.targetFrame;
    
    if (targetFrameInfo) {
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else {
        
        NSURL *url = navigationAction.request.URL;
        
        [[UIApplication sharedApplication] openURL:url];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

// 决定是否接收响应
// 这个是决定是否接收response
// 要获取response，通过WKNavigationResponse对象获取
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 当main frame的导航开始请求时，会调用此方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame接收到服务重定向时，会回调此方法
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

// 当main frame的web内容开始到达时，会回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

// 当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    __weak typeof(self) weakSelf = self;
    
    // 获取图片Url数组
    
    [self.webView evaluateJavaScript:@"getImageInfos()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        if (!weakSelf) return ;
        
        if (!error && response) {
            
            [weakSelf.imageInfoArray removeAllObjects];
            
            [weakSelf.imageInfoArray addObjectsFromArray:[response copy]];
            
            // 加载图片
            
            switch (weakSelf.loadMode) {
                    
                case ContentImageLoadModeAll:
                    
                    [weakSelf loadImages];
                    
                    break;
                    
                case ContentImageLoadModeScroll:
                    
                    [weakSelf scroll:CGPointMake(0, weakSelf.webView.top)];
                    
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }];
    
    // 更新webview高度
    
    [weakSelf updateHeight];
    
    weakSelf.displayLink.paused = NO;
    
    if (weakSelf.loadedFinishBlock) weakSelf.loadedFinishBlock(YES);
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

// 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    
    //AFNetworking中的处理方式
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    
    __block NSURLCredential *credential = nil;
    
    //判断服务器返回的证书是否是服务器信任的
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        /*disposition：如何处理证书
         NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
         NSURLSessionAuthChallengeUseCredential：使用指定的证书    NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
         */
        if (credential) {
            
            disposition = NSURLSessionAuthChallengeUseCredential;
            
        } else {
            
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
    } else {
        
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    //安装证书
    
    if (completionHandler) completionHandler(disposition, credential);
}

// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    [webView reload];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
    // NSDictionary, and NSNull类型
    
    // 加载图片
    
    if ([message.name isEqualToString:ScriptName_loadImage]) {
        
        [self loadImage:[message.body integerValue] ResultBlock:^{}];
    }
    
    // 加载Gif图片
    
    if ([message.name isEqualToString:ScriptName_loadGifImage]) {
        
        [self loadGifImage:[message.body integerValue] ResultBlock:^{}];
    }
    
    // 点击图片
    
    if ([message.name isEqualToString:ScriptName_clickImage]) {
        
        NSMutableArray *urlArray = [NSMutableArray array];
        
        for (NSDictionary *info in self.imageInfoArray) {
            
            [urlArray addObject:info[@"original"]];
        }
        
        [self openPhotoBrowserWithUrlArray:[urlArray copy] Index:[message.body integerValue]];
    }
    
}

@end
