//
//  XMAppLockPatternView.h
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMAppLockPatternItemView.h"
@class XMAppLockPatternLayout;

typedef NS_ENUM(NSInteger, XMAppLockPatternViewType) {
    XMAppLockPatternViewTypeNomal,
    XMAppLockPatternViewTypeError
};

typedef void(^appLockPatternViewDidCompleted)(NSString *password);

@interface XMAppLockPatternView : UIView

/* 样式设置 */
@property(nonatomic, strong)XMAppLockPatternLayout *layout;
/* 状态 */
@property(nonatomic, assign)XMAppLockPatternViewType type;

/* 完成回调 */
@property(nonatomic, copy)appLockPatternViewDidCompleted appLockPatternViewDidCompleted;

- (instancetype)initWithFrame:(CGRect)frame layout:(XMAppLockPatternLayout *)layout;

@end

@interface XMAppLockPatternLayout : NSObject

/* 按钮大小 */
@property(nonatomic, assign)CGSize itemSize;
/* 按钮之间的间隔 */
@property(nonatomic, assign)CGFloat itemSpace;
/* 线宽 */
@property(nonatomic, assign)CGFloat lineWidth;
/* 内部圆圈大小 */
@property(nonatomic, assign)CGSize insideCircleSize;
/* 普通状态item样式 */
@property(nonatomic, strong)XMAppLockPatternItemStyle *nomalStyle;
/* 高亮状态item样式 */
@property(nonatomic, strong)XMAppLockPatternItemStyle *selectedStyle;
/* 错误状态item样式 */
@property(nonatomic, strong)XMAppLockPatternItemStyle *errorStyle;

+ (instancetype)defaultLayout;

@end
