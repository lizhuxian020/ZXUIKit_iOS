//
//  ZXButton.h
//  ZXUIKit_example
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXButtonType) {
    ZXButtonType_Normal,
    ZXButtonType_Rectangle,
    ZXButtonType_Stroke,
    ZXButtonType_Text
};

@interface ZXButton : UIButton

- (instancetype)initWithTitle:(NSString *)title
                    attribute:(NSDictionary *)attribute
                        color:(UIColor *)color
                         type:(ZXButtonType)type;
@end
