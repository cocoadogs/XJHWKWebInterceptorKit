//
//  XJHWKWebViewController+ScriptMessageHandler.h
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/14.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import "XJHWKWebViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHWKWebViewController (ScriptMessageHandler)<WKScriptMessageHandler>

- (WKUserContentController *)configScriptMessageHandler;

@end

NS_ASSUME_NONNULL_END
