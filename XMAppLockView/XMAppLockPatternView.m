//
//  XMAppLockPatternView.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "XMAppLockPatternView.h"

static CGFloat const kDefaultPoint = -1000;

@interface XMAppLockPatternView()

/* 手势 */
@property(nonatomic, strong)UIPanGestureRecognizer *pan;
/* 可以点击的视图 */
@property(nonatomic, strong)NSMutableArray<XMAppLockPatternItemView *> *canTouchViews;
/* 直线数组 */
@property(nonatomic, strong)NSMutableArray<CAShapeLayer *> *lineArray;
/* 上一个点的point */
@property(nonatomic, assign)CGPoint lastPoint;
/* 是否开始画线 */
@property(nonatomic, assign)BOOL isStart;
/* 是否可以操作 */
@property(nonatomic, assign)BOOL canOperate;
/* 密码数组 */
@property(nonatomic, strong)NSMutableArray<NSNumber *> *passwordArray;

@end

@implementation XMAppLockPatternView

- (instancetype)initWithFrame:(CGRect)frame layout:(XMAppLockPatternLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        _layout = layout;
        [self initLayout];
    }
    return self;
}

- (void)initData
{
    _lastPoint = CGPointMake(kDefaultPoint, kDefaultPoint);
    _isStart = NO;
    _canOperate = YES;
}

- (void)initLayout
{
    [self initData];
    CGFloat left = (CGRectGetWidth(self.frame)-(_layout.itemSize.width*3+_layout.itemSpace*2))/2;
    CGFloat top = (CGRectGetHeight(self.frame)-(_layout.itemSize.height*3+_layout.itemSpace*2))/2;
    for (int i = 0; i<9; i++) {
        NSInteger x = i%3;
        NSInteger y = i/3;
        XMAppLockPatternItemView *item = [[XMAppLockPatternItemView alloc] initWithFrame:CGRectMake(left+x*(_layout.itemSize.width+_layout.itemSpace), top+y*(_layout.itemSize.height+_layout.itemSpace), _layout.itemSize.width, _layout.itemSize.height)];
        item.tag = i+1;
        item.insideCircleSize = _layout.insideCircleSize;
        item.style = _layout.nomalStyle;
        [self addSubview:item];
        [self.canTouchViews addObject:item];
    }
    [self addGestureRecognizer:self.pan];
}

- (void)clear
{
    [self initData];
    for (CAShapeLayer *layer in self.lineArray) {
        [layer removeFromSuperlayer];
    }
    [self.lineArray removeAllObjects];
    [self.canTouchViews removeAllObjects];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[XMAppLockPatternItemView class]]) {
            XMAppLockPatternItemView *item = (XMAppLockPatternItemView *)view;
            item.style = _layout.nomalStyle;
            [self.canTouchViews addObject:item];
        }
    }
    
    [self.passwordArray removeAllObjects];
}

#pragma mark - 手势
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.canTouchViews.count == 9 && _canOperate) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        [self handlerMovePoint:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.canOperate = NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (!_canOperate) return;
    CGPoint point = [recognizer locationInView:self];
    [self handlerMovePoint:point];
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed) {
        self.canOperate = NO;
    }
}

- (void)handlerMovePoint:(CGPoint)point
{
    BOOL isContinue = YES;
    for (XMAppLockPatternItemView *view in self.canTouchViews) {
        CGPoint newPoint = [self convertPoint:point toView:view];
        if ([view.layer containsPoint:newPoint]) {
            view.style = _layout.selectedStyle;
            [self.canTouchViews removeObject:view];
            /* 结束画线到这个点 */
            if (_lastPoint.x != kDefaultPoint && _lastPoint.y != kDefaultPoint) {
                /* 移除临时线 */
                [self removeLastLine];
                CAShapeLayer *layer = [self createShapeLayer:view.center];
                [self.layer addSublayer:layer];
                [self.lineArray addObject:layer];
            }
            _lastPoint = view.center;
            _isStart = YES;
            NSNumber *numb = [NSNumber numberWithInteger:view.tag];
            if ([self.passwordArray containsObject:numb]) [self.passwordArray removeObject:numb];
            [self.passwordArray addObject:numb];
            isContinue = NO;
            break;
        }
    }
    if (isContinue && self.canTouchViews.count != 9) {
        /* 移除临时线 */
        [self removeLastLine];
        CAShapeLayer *layer = [self createShapeLayer:point];
        [self.layer addSublayer:layer];
        [self.lineArray addObject:layer];
        _isStart = NO;
    }
}

- (void)removeLastLine
{
    if (self.lineArray.count>0 && !_isStart) {
        CAShapeLayer *layer = [self.lineArray lastObject];
        [layer removeFromSuperlayer];
        [self.lineArray removeLastObject];
    }
}

- (CAShapeLayer *)createShapeLayer:(CGPoint)point
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:_lastPoint];
    [linePath addLineToPoint:point];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = _layout.lineWidth;
    lineLayer.strokeColor = _layout.nomalStyle.lineColor.CGColor;
    lineLayer.path = linePath.CGPath;
    
    return lineLayer;
}

- (void)setCanOperate:(BOOL)canOperate
{
    if (_canOperate == canOperate) return;
    _canOperate = canOperate;
    if (!_canOperate) {
        /* 移除临时线 */
        [self removeLastLine];
        if (_appLockPatternViewDidCompleted) {
            NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
            for (NSNumber *numb in self.passwordArray) {
                [string appendString:[NSString stringWithFormat:@"%ld",(long)[numb integerValue]]];
            }
            _appLockPatternViewDidCompleted(string);
        }
    }
}

- (void)setType:(XMAppLockPatternViewType)type
{
    _type = type;
    if (_type == XMAppLockPatternViewTypeNomal) {
        [self clear];
    }else if (_type == XMAppLockPatternViewTypeError) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[XMAppLockPatternItemView class]]) {
                XMAppLockPatternItemView *item = (XMAppLockPatternItemView *)view;
                if (![self.canTouchViews containsObject:item]) item.style = _layout.errorStyle;
            }
        }
        for (CAShapeLayer *layer in self.lineArray) {
            layer.strokeColor = _layout.errorStyle.lineColor.CGColor;
        }
    }
}

#pragma mark - lazy
- (UIPanGestureRecognizer *)pan
{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return _pan;
}

- (NSMutableArray<XMAppLockPatternItemView *> *)canTouchViews
{
    if (!_canTouchViews) {
        _canTouchViews = [NSMutableArray array];
    }
    return _canTouchViews;
}

- (NSMutableArray<CAShapeLayer *> *)lineArray
{
    if (!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

- (NSMutableArray<NSNumber *> *)passwordArray
{
    if (!_passwordArray) {
        _passwordArray = [NSMutableArray array];
    }
    return _passwordArray;
}

@end

@implementation XMAppLockPatternLayout

+ (instancetype)defaultLayout
{
    XMAppLockPatternLayout *layout = [[XMAppLockPatternLayout alloc] init];
    layout.itemSize = CGSizeMake(60, 60);
    layout.itemSpace = 44;
    layout.lineWidth = 5;
    layout.insideCircleSize = CGSizeMake(24, 24);
    layout.nomalStyle = [[XMAppLockPatternItemStyle alloc] initWithOutsideCircleColor:[UIColor clearColor] insideCircleColor:[UIColor colorWithRed:208/255.0 green:216/255.0 blue:223/255.0 alpha:1] lineColor:[UIColor colorWithRed:255/255.0 green:230/255.0 blue:0/255.0 alpha:1]];
    layout.selectedStyle = [[XMAppLockPatternItemStyle alloc] initWithOutsideCircleColor:[UIColor colorWithRed:255/255.0 green:230/255.0 blue:0/255.0 alpha:0.3] insideCircleColor:[UIColor colorWithRed:255/255.0 green:230/255.0 blue:0/255.0 alpha:1] lineColor:[UIColor colorWithRed:255/255.0 green:230/255.0 blue:0/255.0 alpha:1]];
    layout.errorStyle = [[XMAppLockPatternItemStyle alloc] initWithOutsideCircleColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:0.3] insideCircleColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1] lineColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1]];
    return layout;
}


@end
