//
//  XJHViewController.m
//  XJHWKWebInterceptorKit
//
//  Created by cocoadogs on 09/09/2020.
//  Copyright (c) 2020 cocoadogs. All rights reserved.
//

#import "XJHViewController.h"
#import "XJHWKWebViewController.h"
#import "XJHTextFieldViewController.h"
#import <XJHWKWebInterceptorKit/XJHWKInterceptorViewController.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@interface XJHViewController ()

@property (nonatomic, strong) UIButton *web1Btn;

@property (nonatomic, strong) UIButton *web2Btn;

@property (nonatomic, strong) UIButton *injectorBtn;

@property (nonatomic, strong) UIButton *textBtn;

@end

@implementation XJHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.web1Btn];
    [self.view addSubview:self.web2Btn];
    [self.view addSubview:self.injectorBtn];
    [self.view addSubview:self.textBtn];
    [self.web1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-40);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.web2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.web1Btn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.injectorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.web2Btn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [self.textBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.injectorBtn.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Property Methods

- (UIButton *)web1Btn {
    if (!_web1Btn) {
        _web1Btn = [[UIButton alloc] init];
        [_web1Btn setTitle:@"百度" forState:UIControlStateNormal];
        [_web1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_web1Btn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular]];
        //6E91F5
        [_web1Btn setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:110/255.0f green:145/255.0f blue:245/255.0f alpha:1.0]] forState:UIControlStateNormal];
        _web1Btn.layer.cornerRadius = 3.0f;
        _web1Btn.layer.masksToBounds = YES;
        @weakify(self)
        [[_web1Btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            XJHWKWebViewController *webVC = [[XJHWKWebViewController alloc] init];
            webVC.url = @"https://www.baidu.com";
            [self.navigationController pushViewController:webVC animated:YES];
        }];
    }
    return _web1Btn;
}

- (UIButton *)web2Btn {
    if (!_web2Btn) {
        _web2Btn = [[UIButton alloc] init];
        [_web2Btn setTitle:@"网易" forState:UIControlStateNormal];
        [_web2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_web2Btn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular]];
        [_web2Btn setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:110/255.0f green:145/255.0f blue:245/255.0f alpha:1.0]] forState:UIControlStateNormal];
        _web2Btn.layer.cornerRadius = 3.0f;
        _web2Btn.layer.masksToBounds = YES;
        @weakify(self)
        [[_web2Btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            XJHWKWebViewController *webVC = [[XJHWKWebViewController alloc] init];
            webVC.url = @"https://www.163.com";
            [self.navigationController pushViewController:webVC animated:YES];
        }];
    }
    return _web2Btn;
}

- (UIButton *)injectorBtn {
    if (!_injectorBtn) {
        _injectorBtn = [[UIButton alloc] init];
        [_injectorBtn setTitle:@"拦截" forState:UIControlStateNormal];
        [_injectorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_injectorBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular]];
        [_injectorBtn setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:110/255.0f green:145/255.0f blue:245/255.0f alpha:1.0]] forState:UIControlStateNormal];
        _injectorBtn.layer.cornerRadius = 3.0f;
        _injectorBtn.layer.masksToBounds = YES;
        @weakify(self)
        [[_injectorBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            XJHWKInterceptorViewController *injectorVC = [[XJHWKInterceptorViewController alloc] init];
            [self.navigationController pushViewController:injectorVC animated:YES];
        }];
    }
    return _injectorBtn;
}

- (UIButton *)textBtn {
    if (!_textBtn) {
        _textBtn = [[UIButton alloc] init];
        [_textBtn setTitle:@"输入框" forState:UIControlStateNormal];
        [_textBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_textBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular]];
        [_textBtn setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:110/255.0f green:145/255.0f blue:245/255.0f alpha:1.0]] forState:UIControlStateNormal];
        _textBtn.layer.cornerRadius = 3.0f;
        _textBtn.layer.masksToBounds = YES;
        @weakify(self)
        [[_textBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.navigationController pushViewController:[[XJHTextFieldViewController alloc] init] animated:YES];
        }];
    }
    return _textBtn;
}


#pragma mark - Class Methods

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
