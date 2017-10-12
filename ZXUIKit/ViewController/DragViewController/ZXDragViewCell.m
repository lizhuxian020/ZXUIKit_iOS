//
//  ZXDragViewCell.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/11.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDragViewCell.h"

@interface ZXDragViewCell()

@property(nonatomic, strong) UILabel *title;

@end

@implementation ZXDragViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _title = [[UILabel alloc] init];
    [self.contentView addSubview:_title];
    _title.zx_size = CGSizeMake(80, 40);
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
}

- (void)setData:(DragCellModel *)data {
    _data = data;
    self.backgroundColor = data.bgColor;
    self.title.text = data.title;
//    [self.title sizeToFit];
}

@end
