//
//  XJHWKURLProtocol.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/14.
//

#import "XJHWKURLProtocol.h"
#import "XJHWKWebDataSource.h"
#import <XJHNetworkInterceptorKit/XJHNetFlowHttpModel.h>

@interface XJHWKURLProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSURLRequest *taskRequest;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation XJHWKURLProtocol

- (void)setUrlSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    _urlSchemeTask = urlSchemeTask;
    self.taskRequest = self.urlSchemeTask.request;
}

#pragma mark - Override Methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    self.data = [NSMutableData data];
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.task = [self.session dataTaskWithRequest:self.taskRequest];
    [self.task resume];
}

- (void)stopLoading {
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}

#pragma mark - NSURLSessionDataDelegate Methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    self.response = response;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    //判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //强制信任
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    XJHNetFlowHttpModel *model = [XJHNetFlowHttpModel dealWithResponseData:self.data response:self.response request:self.taskRequest];
    model.startTime = self.startTime;
    model.endTime = [[NSDate date] timeIntervalSince1970];
    model.totalDuration = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] - self.startTime];
    [[XJHWKWebDataSource sharedInstance] addHttpModel:model];
    
    if (error) {
        [self.urlSchemeTask didReceiveResponse:self.response];
        [self.urlSchemeTask didFailWithError:error];
    } else {
        [self.urlSchemeTask didReceiveResponse:self.response];
        [self.urlSchemeTask didReceiveData:self.data];
        [self.urlSchemeTask didFinish];
    }
}


#pragma mark - Property Methods

- (NSURLSession *)session {
    if (!_session) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        [queue setName:@"XJHWKURLProtocolSessionQueue"];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
        _session.sessionDescription = @"XJHWKURLProtocolSession";
    }
    return _session;
}



@end
