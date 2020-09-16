//
//  XJHWKURLHandler.h
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/14.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

API_AVAILABLE(ios(11.0))
@interface XJHWKURLHandler : NSObject<WKURLSchemeHandler>

+ (instancetype)sharedInstance;

@end

