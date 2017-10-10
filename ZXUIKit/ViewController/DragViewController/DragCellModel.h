//
//  DragCellModel.h
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DragCellModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *bgColor;

+ (instancetype)modelWithTitle:(NSString *)title gbColor:(UIColor *)color;

@end
