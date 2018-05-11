//
//  XMAppLockPatternItemView.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "XMAppLockPatternItemView.h"

@interface XMAppLockPatternItemView()

/* 底部大圈 */
@property(nonatomic, strong)UIView *bigCircle;
/* 小圈 */
@property(nonatomic, strong)UIView *smallCircle;

@end

@implementation XMAppLockPatternItemView

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
    [self addSubview:self.bigCircle];
    [self addSubview:self.smallCircle];
}

- (void)setStyle:(XMAppLockPatternItemStyle *)style
{
    _style = style;
    [UIView animateWithDuration:0.2 animations:^{
        self.bigCircle.backgroundColor = self.style.outsideCircleColor;
        self.smallCircle.backgroundColor = self.style.insideCircleColor;
    }];
}

- (void)setInsideCircleSize:(CGSize)insideCircleSize
{
    _insideCircleSize = insideCircleSize;
    CGRect frame = _smallCircle.frame;
    frame.size = _insideCircleSize;
    _smallCircle.frame = frame;
    _smallCircle.layer.cornerRadius = _insideCircleSize.width/2;
    _smallCircle.center = _bigCircle.center;
}

#pragma mark - lazy
- (UIView *)bigCircle
{
    if (!_bigCircle) {
        _bigCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _bigCircle.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
        _bigCircle.layer.masksToBounds = YES;
    }
    return _bigCircle;
}

- (UIView *)smallCircle
{
    if (!_smallCircle) {
        _smallCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _insideCircleSize.width, _insideCircleSize.height)];
        _smallCircle.layer.cornerRadius = _insideCircleSize.height/2;
        _smallCircle.layer.masksToBounds = YES;
        _smallCircle.center = self.bigCircle.center;
    }
    return _smallCircle;
}

@end

@implementation XMAppLockPatternItemStyle

- (instancetype)initWithOutsideCircleColor:(UIColor *)outsideCircleColor insideCircleColor:(UIColor *)insideCircleColor lineColor:(UIColor *)lineColor
{
    self = [super init];
    if (self) {
        self.outsideCircleColor = outsideCircleColor;
        self.insideCircleColor = insideCircleColor;
        self.lineColor = lineColor;
    }
    return self;
}

@end
