//
//  XJHWKInterceptorViewController.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 2020/9/9.
//
// cocoadogs@163.com

#import "XJHWKInterceptorViewController.h"
#import <XJHNetworkInterceptorKit/XJHRequestResponseDetailViewController.h>
#import <XJHNetworkInterceptorKit/XJHNetworkInterceptorViewCell.h>
#import "XJHWKRequestResponseViewModel.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width

#define EM_NAVCONTENT_HEIGHT 44

#define EM_STATUSBAR_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height
#define EM_NAVBAR_HEIGHT (EM_STATUSBAR_HEIGHT + EM_NAVCONTENT_HEIGHT)

@interface XJHWKInterceptorViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XJHWKRequestResponseViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *clearItem;

@end

@implementation XJHWKInterceptorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self buildUI];
	[self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)showDetail:(XJHNetFlowHttpModel *)model {
    XJHRequestResponseDetailViewController *detailVC = [[XJHRequestResponseDetailViewController alloc] init];
    detailVC.httpModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHNetworkInterceptorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[XJHNetworkInterceptorViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier"];
    }
    cell.viewModel = self.viewModel.items[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.items[indexPath.row].height;
}

#pragma mark - ViewModel Bind Method

- (void)bindViewModel {
    @weakify(self)
    [self.viewModel.clearCommand.executionSignals subscribeNext:^(RACSignal *signal) {
        [signal subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.tableView reloadData];
        }];
    }];
    [self.viewModel.selectionSignal subscribeNext:^(XJHNetFlowHttpModel *model) {
        @strongify(self)
        [self showDetail:model];
    }];
    self.clearItem.rac_command = self.viewModel.clearCommand;
}

#pragma mark - Build UI Method

- (void)buildUI {
	self.navigationItem.title = @"Request & Response";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationItem.rightBarButtonItem = self.clearItem;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, EM_NAVBAR_HEIGHT, SCREEN_WIDTH, self.view.frame.size.height - EM_NAVBAR_HEIGHT);
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count <= 1) {
        self.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:({
                UIBarButtonSystemItem style = UIBarButtonSystemItemStop;
                if (@available(iOS 13.0, *)) {
                    style = UIBarButtonSystemItemClose;
                }
                style;
            }) target:nil action:nil];
            @weakify(self)
            item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                    @strongify(self)
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];
            item;
        });
    }
}

#pragma mark - Property Methods

- (XJHWKRequestResponseViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XJHWKRequestResponseViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[XJHNetworkInterceptorViewCell class] forCellReuseIdentifier:@"kXJHNetworkInterceptorViewCellIdentifier"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, CGFLOAT_MIN, 0, CGFLOAT_MIN);
        _tableView.separatorColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIBarButtonItem *)clearItem {
    if (!_clearItem) {
        _clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:nil action:nil];
    }
    return _clearItem;
}


@end
