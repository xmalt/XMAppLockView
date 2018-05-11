//
//  XMAppLockKeyboard.h
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMAppLockKeyboardLayout;

/* 键盘按键 */
#define keyboardArray @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"btn_delete"]

@protocol XMAppLockKeyboardDelegate<NSObject>

- (void)appLockKeyboardDidSelectedIndex:(NSInteger)index;

@end

@interface XMAppLockKeyboard : UIView

/* 样式 */
@property(nonatomic, strong)XMAppLockKeyboardLayout *layout;
/* 事件回调 */
@property(nonatomic, weak)id<XMAppLockKeyboardDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame layout:(XMAppLockKeyboardLayout *)layout;

@end

@interface XMAppLockKeyboardLayout : NSObject

/* 按键大小 */
@property(nonatomic, assign)CGSize itemSize;
/* 水平间隔 */
@property(nonatomic, assign)CGFloat horizontalSpace;
/* 垂直间隔 */
@property(nonatomic, assign)CGFloat verticalSpace;
/* 普通背景颜色 */
@property(nonatomic, strong)UIColor *nomalBackgroundColor;
/* 高亮背景颜色 */
@property(nonatomic, strong)UIColor *hightlightBackgroundColor;
/* 正常文字颜色 */
@property(nonatomic, strong)UIColor *nomalTextColor;
/* 高亮文字颜色 */
@property(nonatomic, strong)UIColor *hightlightTextColor;
/* 文字字体 */
@property(nonatomic, strong)UIFont *textFont;
/* 删除按钮图片 */
@property(nonatomic, strong)UIImage *deleteImage;

+ (instancetype)defaultLayout;

@end
