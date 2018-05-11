//
//  XMAppLockKeyboard.m
//  XMAppLockView-master
//
//  Created by 高昇 on 2018/5/11.
//  Copyright © 2018年 xmalt. All rights reserved.
//

#import "XMAppLockKeyboard.h"

@implementation XMAppLockKeyboard

- (instancetype)initWithFrame:(CGRect)frame layout:(XMAppLockKeyboardLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        _layout = layout;
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    NSArray *array = keyboardArray;
    CGFloat top = (CGRectGetHeight(self.frame)-4*_layout.itemSize.height-3*_layout.verticalSpace)/2;
    CGFloat left = (CGRectGetWidth(self.frame)-3*_layout.itemSize.width-2*_layout.horizontalSpace)/2;
    
    for (int i = 0; i<array.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left+i%3*(_layout.itemSize.width+_layout.horizontalSpace), top+i/3*(_layout.itemSize.height+_layout.verticalSpace), _layout.itemSize.width, _layout.itemSize.height)];
        btn.layer.cornerRadius = _layout.itemSize.width/2;
        btn.layer.masksToBounds = YES;
        if (i == array.count-1) {
            [btn setImage:_layout.deleteImage forState:UIControlStateNormal];
        }else {
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:_layout.nomalTextColor forState:UIControlStateNormal];
        }
        btn.tag = i+1;
        btn.titleLabel.font = _layout.textFont;
        [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
    }
}

- (void)touchDown:(UIButton *)sender
{
    if (sender.tag == 10) return;
    sender.backgroundColor = _layout.hightlightBackgroundColor;
    [sender setTitleColor:_layout.hightlightTextColor forState:UIControlStateNormal];
}

- (void)touchUpInside:(UIButton *)sender
{
    if (sender.tag == 10) return;
    if ([self.delegate respondsToSelector:@selector(appLockKeyboardDidSelectedIndex:)]) {
        [self.delegate appLockKeyboardDidSelectedIndex:sender.tag-1];
    }
    [self handlerTouchCompletedLayout:sender];
}

- (void)touchUpOutside:(UIButton *)sender
{
    if (sender.tag == 10) return;
    [self handlerTouchCompletedLayout:sender];
}

- (void)handlerTouchCompletedLayout:(UIButton *)sender
{
    __weak __typeof(&*self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.075 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.backgroundColor = weakSelf.layout.nomalBackgroundColor;
        [sender setTitleColor:weakSelf.layout.nomalTextColor forState:UIControlStateNormal];
    });
}

@end

@implementation XMAppLockKeyboardLayout

+ (instancetype)defaultLayout
{
    XMAppLockKeyboardLayout *layout = [[XMAppLockKeyboardLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    layout.horizontalSpace = 52.5;
    layout.verticalSpace = 26;
    layout.nomalBackgroundColor = [UIColor colorWithWhite:1 alpha:1];
    layout.nomalTextColor = [UIColor colorWithRed:192/255.0 green:203/255.0 blue:212/255.0 alpha:1];
    layout.hightlightBackgroundColor = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:0/255.0 alpha:1];
    layout.hightlightTextColor = [UIColor colorWithRed:68/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)) {
        layout.textFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    }else {
        layout.textFont = [UIFont boldSystemFontOfSize:24];
    }
    layout.deleteImage = [self imagesNamedFromCustomBundle:@"btn_delete"];
    return layout;
}

+ (UIImage *)imagesNamedFromCustomBundle:(NSString *)imageName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"bundle"];
    return [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]];
}

@end
