//
//  XMAppLockPatternItemView.h
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMAppLockPatternItemStyle;

@interface XMAppLockPatternItemView : UIView

/* 内部圆圈大小 */
@property(nonatomic, assign)CGSize insideCircleSize;
/* 当前状态 */
@property(nonatomic, strong)XMAppLockPatternItemStyle *style;

@end

@interface XMAppLockPatternItemStyle : NSObject

/* 外圈颜色 */
@property(nonatomic, strong)UIColor *outsideCircleColor;
/* 内圈颜色 */
@property(nonatomic, strong)UIColor *insideCircleColor;
/* 连接线的颜色 */
@property(nonatomic, strong)UIColor *lineColor;

- (instancetype)initWithOutsideCircleColor:(UIColor *)outsideCircleColor insideCircleColor:(UIColor *)insideCircleColor lineColor:(UIColor *)lineColor;

@end
