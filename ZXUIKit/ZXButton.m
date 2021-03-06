//
//  ZXButton.m
//  ZXUIKit_example
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXButton.h"
#import <ZXSugarCode.h>

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
        OBJC_ISEMPTY(title) ? title = @"ZXButton": nil;
        OBJC_ISEMPTY(color) ? color = [UIColor blueColor]: nil;
        OBJC_ISEMPTY(attribute) ?
            attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]} : nil;
        _themeColor = color;
        _type = type;
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [attribute valueForKey:NSFontAttributeName];
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

//- (void)makeNormalWithTitle:(NSString *)title color:(UIColor *)color

- (void)showBorder {
    CGFloat scale = [UIScreen mainScreen].scale;
    self.layer.borderWidth = 1.0 / scale;
    self.layer.borderColor = _themeColor.CGColor;
}

#warning 性能不太好..以后改
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
