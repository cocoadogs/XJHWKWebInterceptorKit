//
//  XJHWKRequestResponseViewModel.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//

#import "XJHWKRequestResponseViewModel.h"
#import "XJHWKWebDataSource.h"

@interface XJHWKRequestResponseViewModel ()

@property (nonatomic, copy) NSArray<XJHRequestResponseItemViewModel *> *items;

@property (nonatomic, strong) RACCommand *clearCommand;

@property (nonatomic, strong) RACSubject *selectionSignal;

@end

@implementation XJHWKRequestResponseViewModel

#pragma mark - Init Methods

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

#pragma mark - Private Methods

- (void)initialize {
    NSArray<XJHNetFlowHttpModel *> *list = [XJHWKWebDataSource sharedInstance].httpModelArray;
    NSMutableArray<XJHRequestResponseItemViewModel *> *mItems = [[NSMutableArray<XJHRequestResponseItemViewModel *> alloc] initWithCapacity:list.count];
    for (XJHNetFlowHttpModel *item in list) {
        XJHRequestResponseItemViewModel *vm = [[XJHRequestResponseItemViewModel alloc] initWithModel:item];
        @weakify(self)
        [vm.selectionSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.selectionSignal sendNext:x];
        }];
        !vm?:[mItems addObject:vm];
    }
    self.items = mItems;
}

#pragma mark - Property Methods

- (RACSubject *)selectionSignal {
    if (!_selectionSignal) {
        _selectionSignal = [RACSubject subject];
    }
    return _selectionSignal;
}

- (RACCommand *)clearCommand {
    if (!_clearCommand) {
        @weakify(self)
        _clearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [[XJHWKWebDataSource sharedInstance] clear];
                self.items = nil;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _clearCommand;
}

@end
