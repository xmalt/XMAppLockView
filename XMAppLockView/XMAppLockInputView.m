//
//  XMAppLockInputView.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "XMAppLockInputView.h"
#import "XMWeakProxy.h"

@interface XMAppLockInputView()

/* 输入数字 */
@property(nonatomic, strong)NSMutableArray *inputArray;
/* 定时器 */
@property(nonatomic, strong)NSTimer *timer;

@end

@implementation XMAppLockInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    CGFloat leftEdge = 0;
    for (int i = 0; i<4; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i*56, CGRectGetHeight(self.frame)-3, 32, 3)];
        line.layer.cornerRadius = 2;
        line.layer.masksToBounds = YES;
        line.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
        [self addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 20, 26)];
        label.tag = i+1;
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor clearColor];
        label.center = CGPointMake(line.center.x, label.center.y);
        label.textAlignment = NSTextAlignmentCenter;
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)) {
            label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        }else {
            label.font = [UIFont boldSystemFontOfSize:24];
        }
        label.textColor = [UIColor colorWithRed:68/255.0 green:34/255.0 blue:34/255.0 alpha:1];
        if (i == 0) label.backgroundColor = [UIColor colorWithRed:192/255.0 green:203/255.0 blue:212/255.0 alpha:1];
        [self addSubview:label];
    }
    [self initTimer];
}

- (void)initTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    XMWeakProxy *proxy = [XMWeakProxy proxyWithTarget:self];
    _timer = [NSTimer timerWithTimeInterval:0.75 target:proxy selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)tick:(NSTimer *)timer
{
    if (self.inputArray.count<4) {
        NSInteger tag = self.inputArray.count+1;
        UILabel *label = [self viewWithTag:tag];
        if (label.backgroundColor == [UIColor clearColor]) {
            [UIView animateWithDuration:0.25 animations:^{
                label.backgroundColor = [UIColor colorWithRed:192/255.0 green:203/255.0 blue:212/255.0 alpha:1];
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                label.backgroundColor = [UIColor clearColor];
            }];
        }
    }else {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)inputNumber:(NSString *)number
{
    if (self.inputArray.count>=4) {
        NSString *string = [self.inputArray componentsJoinedByString:@""];
        if ([self.delegate respondsToSelector:@selector(appLockInputViewDidCompleted:)]) {
            [self.delegate appLockInputViewDidCompleted:string];
        }
        return;
    }
    [self.inputArray addObject:number];
    [self reloadInputView];
    if (self.inputArray.count == 4) {
        NSString *string = [self.inputArray componentsJoinedByString:@""];
        if ([self.delegate respondsToSelector:@selector(appLockInputViewDidCompleted:)]) {
            [self.delegate appLockInputViewDidCompleted:string];
        }
    }
}

- (void)deleteNumber
{
    if (self.inputArray.count>0) {
        [self.inputArray removeObjectAtIndex:self.inputArray.count-1];
    }
    [self reloadInputView];
}

- (void)emptyNumber
{
    [self.inputArray removeAllObjects];
    [self reloadInputView];
}

- (void)reloadInputView
{
    for (int i = 0; i<4; i++) {
        NSInteger tag = i+1;
        UILabel *label = [self viewWithTag:tag];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"";
    }
    for (int i = 0; i<self.inputArray.count; i++) {
        NSInteger tag = i+1;
        UILabel *label = [self viewWithTag:tag];
        label.backgroundColor = [UIColor clearColor];
        label.text = self.inputArray[i];
    }
    if (self.inputArray.count<4) {
        NSInteger tag = self.inputArray.count+1;
        UILabel *label = [self viewWithTag:tag];
        label.backgroundColor = [UIColor colorWithRed:192/255.0 green:203/255.0 blue:212/255.0 alpha:1];
    }
    [self initTimer];
}

#pragma mark - lazy
- (NSMutableArray *)inputArray
{
    if (!_inputArray) {
        _inputArray = [NSMutableArray array];
    }
    return _inputArray;
}

@end
