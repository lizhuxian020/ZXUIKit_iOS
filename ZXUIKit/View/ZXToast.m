//
//  ZXToast.m
//  ZXUIKit_example
//
//  Created by forzqy on 2018/6/13.
//  Copyright © 2018 lzx. All rights reserved.
//

#import "ZXToast.h"

@implementation ZXToast


+ (void)showToast:(NSString *)message duration:(float)duration {
    [self showToast:message duration:duration postion:ZXToastPosition_Bottom];
}

+ (void)showToast:(NSString *)message duration:(float)duration postion:(ZXToastPosition)position {
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    
    //满屏 view
//    ZXHitView *container = [[ZXHitView alloc] initWithFrame:kScreenB];
//    [keyWin addSubview:container];
    
    //黑色框框
    UIView *bg_view = [[UIView alloc] init];
    bg_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    bg_view.layer.cornerRadius = 10;
    [keyWin addSubview:bg_view];
    
    //文字
    UILabel *lbl = [UILabel new];
    lbl.text = message;
    lbl.textColor = [UIColor whiteColor];
    [lbl sizeToFit];
    [bg_view addSubview:lbl];
//    [container addSubview:lbl];
    
    //黑色框框大小
    bg_view.zx_width = lbl.zx_width + 30;
    bg_view.zx_height = lbl.zx_height + 20;
    
    //黑色框框位置
    bg_view.center = keyWin.center;
    CGFloat y;
    switch (position) {
        case ZXToastPosition_Top:
            y = 30;
            break;
        case ZXToastPosition_Center:
            y = bg_view.zx_y;
            break;
        case ZXToastPosition_Bottom:
        default:
            y = kScreenH - bg_view.zx_height - 30;
            break;
    }
    bg_view.zx_y = y;
    lbl.center = CGPointMake(bg_view.zx_width / 2, bg_view.zx_height / 2);
    
    //动画
    [UIView animateWithDuration:duration animations:^{
        bg_view.alpha = 0;
    } completion:^(BOOL finished) {
        [bg_view removeFromSuperview];
    }];
}


@end
