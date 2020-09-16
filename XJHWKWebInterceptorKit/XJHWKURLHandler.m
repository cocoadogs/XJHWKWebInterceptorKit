//
//  XJHWKURLHandler.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/14.
//

#import "XJHWKURLHandler.h"
#import <XJHNetworkInterceptorKit/NSURLRequest+XJH.h>
#import <XJHNetworkInterceptorKit/NSObject+XJHSwizzle.h>
#import "XJHWKURLProtocol.h"

@interface XJHWKURLHandler ()

@property (nonatomic, strong) Class protocolClass;

@property (nonatomic, strong) XJHWKURLProtocol *injector;

@end

@implementation XJHWKURLHandler

+ (instancetype)sharedInstance {
    static XJHWKURLHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - WKURLSchemeHandler Methods

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
    self.injector = [[XJHWKURLProtocol alloc] init];
    self.injector.urlSchemeTask = urlSchemeTask;
    [self.injector startLoading];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
    [self.injector stopLoading];
}

@end

#pragma mark - WKWebViewConfiguration Category Methods

@implementation WKWebViewConfiguration (registerURLProtocol)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        [[self class] xjh_swizzleInstanceMethodWithOriginSel:@selector(init) swizzledSel:@selector(xjh_init)];
    }
}

- (instancetype)xjh_init {
    [self xjh_init];
    if (@available(iOS 11.0, *)) {
        [self xjhRegisterURLProtocol:[XJHWKURLProtocol class]];
    }
    return self;
}

- (void)xjhRegisterURLProtocol:(Class)protocolClass {
    if (@available(iOS 11.0, *)) {
        XJHWKURLHandler *handler = [XJHWKURLHandler sharedInstance];
        handler.protocolClass = protocolClass;
        [self setURLSchemeHandler:handler forURLScheme:@"https"];
        [self setURLSchemeHandler:handler forURLScheme:@"http"];
    }
}

@end


#pragma mark - WKWebView Category Methods

@implementation WKWebView (handlesURLScheme)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (BOOL)handlesURLScheme:(NSString *)urlScheme {
    return NO;
}

#pragma clang diagnostic pop

@end
