//
//  XJHTextFieldViewController.m
//  XJHWKWebInterceptorKit_Example
//
//  Created by cocoadogs on 2020/9/15.
//  Copyright © 2020 cocoadogs. All rights reserved.
//

#import "XJHTextFieldViewController.h"
#import <Masonry/Masonry.h>

@interface XJHTextFieldViewController ()

@property (nonatomic, strong) UITextField *inputField;

@end

@implementation XJHTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputField];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.leading.equalTo(self.view).offset(20);
        make.height.mas_equalTo(44);
    }];
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.textAlignment = NSTextAlignmentRight;
        _inputField.borderStyle = UITextBorderStyleNone;
        _inputField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.returnKeyType = UIReturnKeyDone;
        _inputField.placeholder = @"输入框";
        _inputField.delegate = self;
    }
    return _inputField;
}

@end
