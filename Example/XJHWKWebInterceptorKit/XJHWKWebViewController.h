//
//  XJHWKWebViewController.h
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/14.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHWKWebViewController : UIViewController


@property (nonatomic, copy) NSString *url;


@property (nonatomic, strong, readonly) UIProgressView *progressView;

@property (nonatomic, strong, readonly) WKWebView *webView;

@property (nonatomic, strong, readonly) NSMutableSet *scriptMessageHandlerNameSet;

@end

NS_ASSUME_NONNULL_END
