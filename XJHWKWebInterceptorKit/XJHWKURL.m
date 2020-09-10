//
//  XJHWKURL.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import "XJHWKURL.h"
#import "XJHWKURLProtocol.h"
#import <WebKit/WebKit.h>
#import <XJHNetworkInterceptorKit/NSURLRequest+XJH.h>
#import <XJHNetworkInterceptorKit/NSObject+XJHSwizzle.h>

typedef BOOL (^HTTPDNSCookieFilter)(NSHTTPCookie *, NSURL *);

@interface XJHAbstricURLProtocol ()

@property (nonatomic, copy) NSURLRequest *request;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation XJHAbstricURLProtocol


@end

#pragma clang diagnostic pop


#pragma mark - WKURLSchemeHandler Methods

@interface XJHWKURLHandler : NSObject<WKURLSchemeHandler>

@property (nonatomic, strong) Class protocolClass;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation XJHWKURLHandler {
    HTTPDNSCookieFilter cookieFilter;
}

+ (instancetype)sharedInstance {
    static XJHWKURLHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance->cookieFilter = ^BOOL(NSHTTPCookie *cookie, NSURL *URL) {
            return [URL.host containsString:cookie.domain];
        };
    });
    return sharedInstance;
}

#pragma mark - WKURLSchemeHandler Methods

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask {
    NSURLRequest *request = [urlSchemeTask request];
//    NSMutableURLRequest *mutaRequest = [request mutableCopy];
//    [mutaRequest setValue:[self getRequestCookieHeaderForURL:request.URL] forHTTPHeaderField:@"Cookie"];
//    request = [mutaRequest copy];
    BOOL canInit = NO;
    if ([self.protocolClass respondsToSelector:@selector(canInitWithRequest:)]) {
        canInit = [self.protocolClass canInitWithRequest:urlSchemeTask.request];
    }
    if (canInit) {
        if ([self.protocolClass respondsToSelector:@selector(canonicalRequestForRequest:)]) {
            request = [self.protocolClass canonicalRequestForRequest:request];
            XJHAbstricURLProtocol *obj = [[self.protocolClass alloc] init];
            obj.request = request;
            [obj startLoading:^(NSData *data, NSURLResponse *response, NSError *error) {
                dispatch_async(self.queue, ^{
                    if (!urlSchemeTask.request.stop) {
                        if (error) {
                            [urlSchemeTask didReceiveResponse:response];
                            [urlSchemeTask didFailWithError:error];
                        } else {
                            [urlSchemeTask didReceiveResponse:response];
                            [urlSchemeTask didReceiveData:data];
                            [urlSchemeTask didFinish];
//                            if ([response respondsToSelector:@selector(allHeaderFields)]) {
//                                [self handleHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:request.URL];
//                            }
                        }
                    }
                });
            }];
        } else {
            NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(self.queue, ^{
                    if (!urlSchemeTask.request.stop) {
                        if (error) {
                            [urlSchemeTask didReceiveResponse:response];
                            [urlSchemeTask didFailWithError:error];
                        } else {
                            [urlSchemeTask didReceiveResponse:response];
                            [urlSchemeTask didReceiveData:data];
                            [urlSchemeTask didFinish];
//                            if ([response respondsToSelector:@selector(allHeaderFields)]) {
//                                [self handleHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:request.URL];
//                            }
                        }
                    }
                });
            }];
            [task resume];
        }
    }
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask {
    dispatch_async(self.queue, ^{
        urlSchemeTask.request.stop = YES;
    });
}

#pragma mark - Private Methods

- (NSArray<NSHTTPCookie *> *)handleHeaderFields:(NSDictionary *)headerFields forURL:(NSURL *)URL {
    NSArray *cookieArray = [NSHTTPCookie cookiesWithResponseHeaderFields:headerFields forURL:URL];
    if (cookieArray != nil) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieArray) {
            if (cookieFilter(cookie, URL)) {
                [cookieStorage setCookie:cookie];
            }
        }
    }
    return cookieArray;
}

- (NSString *)getRequestCookieHeaderForURL:(NSURL *)URL {
    NSArray *cookieArray = [self searchAppropriateCookies:URL];
    if (cookieArray != nil && cookieArray.count > 0) {
        NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        if ([cookieDic objectForKey:@"Cookie"]) {
            return cookieDic[@"Cookie"];
        }
    }
    return nil;
}

- (NSArray *)searchAppropriateCookies:(NSURL *)URL {
    NSMutableArray *cookieArray = [NSMutableArray array];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if (cookieFilter(cookie, URL)) {
            [cookieArray addObject:cookie];
        }
    }
    return cookieArray;
}

#pragma mark - Property Methods

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _session;
}

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("XJHWKURLHandler.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
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
    [self xjhRegisterURLProtocol:[XJHWKURLProtocol class]];
    return self;
}

- (void)xjhRegisterURLProtocol:(Class)protocolClass {
    XJHWKURLHandler *handler = [XJHWKURLHandler sharedInstance];
    handler.protocolClass = protocolClass;
    [self setURLSchemeHandler:handler forURLScheme:@"https"];
    [self setURLSchemeHandler:handler forURLScheme:@"http"];
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



