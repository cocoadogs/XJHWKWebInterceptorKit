//
//  XJHWeakScriptMessageDelegate.m
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/14.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import "XJHWeakScriptMessageDelegate.h"

@implementation XJHWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    if (self = [super init]) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler Delegte Method

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
