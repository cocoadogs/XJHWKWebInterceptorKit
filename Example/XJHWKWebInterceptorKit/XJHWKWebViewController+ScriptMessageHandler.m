//
//  XJHWKWebViewController+ScriptMessageHandler.m
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/14.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import "XJHWKWebViewController+ScriptMessageHandler.h"
#import "XJHWeakScriptMessageDelegate.h"

@implementation XJHWKWebViewController (ScriptMessageHandler)

- (WKUserContentController *)configScriptMessageHandler {
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    NSArray *nameArray = @[@"firebase"];
    [self.scriptMessageHandlerNameSet addObjectsFromArray:[nameArray copy]];
    [nameArray enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        [userContentController addScriptMessageHandler:[[XJHWeakScriptMessageDelegate alloc] initWithDelegate:self] name:name];
    }];
    return userContentController;
}

#pragma mark - WKScriptMessageHandler Method

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body[@"command"] isEqual:@"setUserProperty"]) {
      
    } else if ([message.body[@"command"] isEqual: @"logEvent"]) {
      
    }
}

@end
