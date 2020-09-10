//
//  XJHWKRequestResponseViewModel.h
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import <Foundation/Foundation.h>
#import <XJHNetworkInterceptorKit/XJHRequestResponseItemViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHWKRequestResponseViewModel : NSObject

@property (nonatomic, copy, readonly) NSArray<XJHRequestResponseItemViewModel *> *items;

@property (nonatomic, strong, readonly) RACCommand *clearCommand;

@property (nonatomic, strong, readonly) RACSubject *selectionSignal;

@end

NS_ASSUME_NONNULL_END
