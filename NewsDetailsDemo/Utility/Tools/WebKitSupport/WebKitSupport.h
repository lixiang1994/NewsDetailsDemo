//
//  WebKitSupport.h
//  NewsDetailsDemo
//
//  Created by 李响 on 2017/7/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

@interface WebKitSupport : NSObject

@property (nonatomic, strong,readonly) WKProcessPool *processPool;

+ (instancetype)sharedSupport;

+ (NSURLRequest *)fixRequest:(NSURLRequest *)request;

+ (NSURL *)urlAddParams:(NSURL *)url Params:(NSDictionary *)params;

@end

@interface NSHTTPCookie (Utils)

- (NSString *)lee_javascriptString;

@end

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic , weak ) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@interface WKWebView (CrashHandle)

@end
