//
//  XJHWKURLProtocol.h
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/14.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

API_AVAILABLE(ios(11.0))
@interface XJHWKURLProtocol : NSURLProtocol

@property (nonatomic, strong) id<WKURLSchemeTask> urlSchemeTask;

@end
