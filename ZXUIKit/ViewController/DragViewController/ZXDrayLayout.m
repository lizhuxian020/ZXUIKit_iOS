//
//  ZXDrayLayout.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDrayLayout.h"

#define kItemSpace 3

@implementation ZXDrayLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    CGFloat itemW = (kScreenW - 3 * kItemSpace) / 4.0;
    self.itemSize = CGSizeMake(itemW, itemW);
    self.minimumLineSpacing = kItemSpace;
    self.minimumInteritemSpacing = kItemSpace;
    self.headerReferenceSize = CGSizeMake(0, 30);
    
}

@end
