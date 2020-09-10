//
//  XJHWKURL.h
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import <Foundation/Foundation.h>

@interface XJHAbstricURLProtocol : NSObject

@property (nonatomic, copy, readonly) NSURLRequest *request;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request;
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;
- (void)startLoading:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (void)stopLoading;

@end
