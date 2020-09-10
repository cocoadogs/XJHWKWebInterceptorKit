//
//  XJHWKWebDataSource.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import "XJHWKWebDataSource.h"

@implementation XJHWKWebDataSource {
    dispatch_semaphore_t semaphore;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _httpModelArray = [NSMutableArray array];
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addHttpModel:(XJHNetFlowHttpModel *)httpModel{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [_httpModelArray insertObject:httpModel atIndex:0];
    dispatch_semaphore_signal(semaphore);
}

- (void)clear{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [_httpModelArray removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

@end
