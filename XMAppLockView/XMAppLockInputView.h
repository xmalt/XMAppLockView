//
//  XMAppLockInputView.h
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMAppLockInputViewDelegate<NSObject>

- (void)appLockInputViewDidCompleted:(NSString *)string;

@end

@interface XMAppLockInputView : UIView

/* 完成回调 */
@property(nonatomic, weak)id<XMAppLockInputViewDelegate> delegate;

- (void)inputNumber:(NSString *)number;

- (void)deleteNumber;

- (void)emptyNumber;

@end
