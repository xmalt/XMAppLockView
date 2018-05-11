//
//  PatternViewController.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "PatternViewController.h"
#import "XMAppLockPatternView.h"

@interface PatternViewController ()

/* 手势视图 */
@property(nonatomic, strong)XMAppLockPatternView *patternView;

@end

@implementation PatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = @"图案密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.patternView];
}

#pragma mark - lazy
- (XMAppLockPatternView *)patternView
{
    if (!_patternView) {
        _patternView = [[XMAppLockPatternView alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 400) layout:[XMAppLockPatternLayout defaultLayout]];
        __weak __typeof(&*self) weakSelf = self;
        _patternView.appLockPatternViewDidCompleted = ^(NSString *password) {
            weakSelf.patternView.type = XMAppLockPatternViewTypeError;
        };
    }
    return _patternView;
}

@end
