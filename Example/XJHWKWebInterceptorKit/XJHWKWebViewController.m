//
//  XJHWKWebViewController.m
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/14.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import "XJHWKWebViewController.h"
#import "XJHWKWebViewController+NavigationDelegate.h"
#import "XJHWKWebViewController+ScriptMessageHandler.h"
#import <objc/runtime.h>
#import <XJHViewState/XJHViewState.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@interface XJHWKWebViewController ()

@property (nonatomic, strong) NSMutableSet *scriptMessageHandlerNameSet;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation XJHWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindViewModel];
    [self buildUI];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url?:@""] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]];
}

#pragma mark - Init Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                self.automaticallyAdjustsScrollViewInsets = NO;
                #pragma clang diagnostic pop
            }
        }
    }
    return self;
}

#pragma mark - Dealloc Methods

- (void)dealloc {
    //must do this, or you get crash
    _webView.scrollView.delegate = nil;
    [[_webView configuration].userContentController removeAllUserScripts];
    [_scriptMessageHandlerNameSet enumerateObjectsUsingBlock:^(NSString *name, BOOL * _Nonnull stop) {
        [[_webView configuration].userContentController removeScriptMessageHandlerForName:name];
    }];
}

#pragma mark - Clean Cache Method

- (void)cleanWebKitCaches {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        NSLog(@"---成功清除9.0系统的WKWebView缓存");
    }];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    NSLog(@"------成功清除WKWebView缓存------");
}

- (void)bindViewModel {
    @weakify(self)
    if ([self.title length] == 0) {
        [[RACObserve(self.webView, title) distinctUntilChanged] subscribeNext:^(NSString *webTitle) {
            @strongify(self)
            self.navigationItem.title = webTitle;
        }];
    } else {
        self.navigationItem.title = self.title;
    }
    
    RAC(self.progressView, progress) = RACObserve(self.webView, estimatedProgress);
}

#pragma mark - UI Component Build Method

- (void)buildUI {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.webView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.and.trailing.equalTo(self.webView);
    }];
}

#pragma mark - Lazy Load Methods

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.selectionGranularity = WKSelectionGranularityCharacter;
        WKPreferences  *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptEnabled = YES;
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.preferences = preferences;
        configuration.userContentController = [self configScriptMessageHandler];
        configuration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:132/255.0f blue:96/255.0f alpha:1];
        _progressView.trackTintColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (NSMutableSet *)scriptMessageHandlerNameSet {
    if (!_scriptMessageHandlerNameSet) {
        _scriptMessageHandlerNameSet = [[NSMutableSet alloc] initWithCapacity:1];
    }
    return _scriptMessageHandlerNameSet;
}

#pragma mark - Load Methods

+ (void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self setup];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}

+ (void)setup {
    const char *className = @"WKContentView".UTF8String;
    Class WKContentViewClass = objc_getClass(className);
    SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
    SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
    BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
    BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
    if (!addIsSecureTextEntry || !addSecureTextEntry) {
        NSLog(@"WKContentView-Crash->修复失败");
    }
}

/**
 实现WKContentView对象isSecureTextEntry方法
 @return NO
 */
BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

/**
 实现WKContentView对象secureTextEntry方法
 @return NO
 */
BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}


@end
