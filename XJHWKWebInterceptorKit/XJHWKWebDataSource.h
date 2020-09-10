//
//  XJHWKWebDataSource.h
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import <Foundation/Foundation.h>
#import <XJHNetworkInterceptorKit/XJHNetFlowHttpModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHWKWebDataSource : NSObject

@property (nonatomic, strong) NSMutableArray<XJHNetFlowHttpModel *> *httpModelArray;

+ (instancetype)sharedInstance;

- (void)addHttpModel:(XJHNetFlowHttpModel *)httpModel;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
