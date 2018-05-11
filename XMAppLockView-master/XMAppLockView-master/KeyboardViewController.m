//
//  KeyboardViewController.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "KeyboardViewController.h"
#import "XMAppLockKeyboard.h"
#import "XMAppLockInputView.h"

@interface KeyboardViewController ()<XMAppLockKeyboardDelegate, XMAppLockInputViewDelegate>

/* 输入框 */
@property(nonatomic, strong)XMAppLockInputView *inputView;
/* 键盘视图 */
@property(nonatomic, strong)XMAppLockKeyboard *keyboard;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = @"数字密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.keyboard];
}

#pragma mark - XMAppLockKeyboardDelegate
- (void)appLockKeyboardDidSelectedIndex:(NSInteger)index
{
    NSString *indexStr = keyboardArray[index];
    if (indexStr.length>1) {
        /* 删除 */
        [self.inputView deleteNumber];
    }else {
        /* 输入 */
        [self.inputView inputNumber:indexStr];
    }
}

- (void)appLockInputViewDidCompleted:(NSString *)string
{
    [self.inputView emptyNumber];
}

#pragma mark - lazy
- (XMAppLockKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[XMAppLockKeyboard alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.inputView.frame)+40, CGRectGetWidth(self.view.frame), 400) layout:[XMAppLockKeyboardLayout defaultLayout]];
        _keyboard.delegate = self;
    }
    return _keyboard;
}

- (XMAppLockInputView *)inputView
{
    if (!_inputView) {
        _inputView = [[XMAppLockInputView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, 130, 200, 39)];
        _inputView.delegate = self;
    }
    return _inputView;
}

@end
