//
//  ZXBlurryView.h
//  ZXUIKit_example
//
//  Created by lzx on 17/4/17.
//  Copyright © 2017年 lzx. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 通过监听系统通知, 进入后台则模糊化(默认开启)
 */
@interface ZXBlurryView : UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame blurryView:(nullable UIView *)view;

@end
