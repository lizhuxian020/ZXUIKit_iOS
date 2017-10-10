//
//  ZXDrayLayout.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDrayLayout.h"

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
    self.itemSize = CGSizeMake(20, 20);
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.headerReferenceSize = CGSizeMake(30, 30);
    self.footerReferenceSize = CGSizeMake(30, 30);
}

@end
