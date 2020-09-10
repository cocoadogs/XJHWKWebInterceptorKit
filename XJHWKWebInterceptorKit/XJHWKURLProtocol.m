//
//  XJHWKURLProtocol.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import "XJHWKURLProtocol.h"
#import "XJHWKWebDataSource.h"
#import <XJHNetworkInterceptorKit/XJHNetFlowHttpModel.h>

@interface XJHWKURLProtocol ()

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession         *session;
@property (nonatomic, assign) NSTimeInterval startTime;

@end

@implementation XJHWKURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
//    ///只缓存get请求
//    if (request.HTTPMethod && ![request.HTTPMethod.uppercaseString isEqualToString:@"GET"]) {
//        return NO;
//    }
    
//    /// 不缓存ajax请求
//    NSString *hasAjax = [request valueForHTTPHeaderField:@"X-Requested-With"];
//    if (!hasAjax) {
//        return NO;
//    }
    
//    NSString *pathExtension = [request.URL.absoluteString componentsSeparatedByString:@"?"].firstObject.pathExtension.lowercaseString;
//    NSArray *validExtension = @[ @"jpg", @"jpeg", @"gif", @"png", @"webp", @"bmp", @"tif", @"ico", @"js", @"css", @"html", @"htm", @"ttf", @"svg"];
//    if (pathExtension && [validExtension containsObject:pathExtension]) {
//        return YES;
//    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    if (request.HTTPBody.length > 0) {
        NSDictionary *headers = @{@"X-TCloud-Authorization": @"customize",
                                  @"X-TCloud-Auth-Type":@"customize",
                                  @"X-TCloud-Auth-Namespace":@"customize"};
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
            [mutableRequest setValue:obj forHTTPHeaderField:key];
        }];
    }
    return [mutableRequest copy];
}

- (void)startLoading:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    self.startTime = [[NSDate date] timeIntervalSince1970];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(data, response, error);
        XJHNetFlowHttpModel *model = [XJHNetFlowHttpModel dealWithResponseData:data response:response request:self.request];
        if (!response || error) {
            model.statusCode = error.localizedDescription;
        }
        model.startTime = self.startTime;
        model.endTime = [[NSDate date] timeIntervalSince1970];
        model.totalDuration = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] - self.startTime];
        [[XJHWKWebDataSource sharedInstance] addHttpModel:model];
        
        if (self.dataTask) {
            [self.dataTask cancel];
            self.dataTask  = nil;
        }
    }];
    self.dataTask = task;
    [task resume];
}

- (void)stopLoading {
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask  = nil;
    }
}

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _session;
}

@end
