//
//  DragCellModel.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "DragCellModel.h"

@implementation DragCellModel

+ (instancetype)modelWithTitle:(NSString *)title gbColor:(UIColor *)color {
    DragCellModel *model = [DragCellModel new];
    model->_title = title;
    model->_bgColor = color;
    return model;
}

@end
