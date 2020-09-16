//
//  XJHWKWebViewController+NavigationDelegate.m
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/14.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import "XJHWKWebViewController+NavigationDelegate.h"
#import <XJHViewState/XJHViewState.h>

@implementation XJHWKWebViewController (NavigationDelegate)

#pragma mark - WKNavigationDelegate Methods

// https 支持
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"---开始加载---");
    self.progressView.hidden = NO;
    //防止progressView被网页挡住
    [webView bringSubviewToFront:self.progressView];
    self.webView.viewState = XJHViewStateLoading;
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *title = webView.title;
    if (title.length > 0) {
        self.navigationItem.title = title;
    }
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    self.webView.viewState = XJHViewStateDefault;
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error {
    self.progressView.hidden = YES;
    self.webView.viewState = XJHViewStateDefault;
}


// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    if ([[navigationAction.request.URL absoluteString] rangeOfString:@"tel"].location != NSNotFound || [[navigationAction.request.URL absoluteString] rangeOfString:@"telprompt"].location != NSNotFound) {
        NSString *resourceSpecifier = [navigationAction.request.URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
