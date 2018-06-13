//
//  ZXToast.h
//  ZXUIKit_example
//
//  Created by forzqy on 2018/6/13.
//  Copyright © 2018 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXToastPosition) {
    ZXToastPosition_Top,
    ZXToastPosition_Center,
    ZXToastPosition_Bottom,
};

@interface ZXToast : NSObject

/**
 *  显示toast, 显示在底部
 *
 *  @param message   toast信息
 *  @param duration  toast显示持续时间
 */
+ (void)showToast:(NSString *)message duration:(float)duration;

/**
 *  显示toast，显示在屏幕正中
 *
 *  @param message   toast信息
 *  @param duration  toast显示持续时间
 *  @param position  toast显示位置
 */
+ (void)showToast:(NSString *)message duration:(float)duration postion:(ZXToastPosition)position;


@end
