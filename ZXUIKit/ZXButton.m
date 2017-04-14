//
//  ZXButton.m
//  ZXUIKit_example
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXButton.h"

@interface ZXButton () {
    UIColor *_themeColor;
    ZXButtonType _type;
}

@end

@implementation ZXButton

- (instancetype)initWithTitle:(NSString *)title
                    attribute:(NSDictionary *)attribute
                        color:(UIColor *)color
                         type:(ZXButtonType)type {
    self = [super init];
    if (self) {
        title == nil || title.length == 0 ? title = @"ZXButton": nil;
        color == nil ? color = [UIColor blueColor]: nil;
        attribute == nil || attribute.allKeys.count == 0 ?
            attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]} : nil;
        _themeColor = color;
        _type = type;
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [attribute valueForKey:NSFontAttributeName];
        self.backgroundColor = [UIColor whiteColor];
        switch (type) {
            case ZXButtonType_Normal:
            case ZXButtonType_Stroke:
            case ZXButtonType_Text:
                [self setTitleColor:color forState:UIControlStateNormal];
                break;
            case ZXButtonType_Rectangle:
                [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    return self;
}

//#warning 性能不太好..以后改
- (void)drawRect:(CGRect)rect {
    [_themeColor set];

    switch (_type) {
        case ZXButtonType_Normal: {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height];
            [path stroke];
            break;
        }
        case ZXButtonType_Stroke: {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            [path stroke];
            break;
        }
        case ZXButtonType_Text:
            break;
        case ZXButtonType_Rectangle: {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            [path fill];
        }
            break;
        default:
            break;
    }
    
    
}

@end
