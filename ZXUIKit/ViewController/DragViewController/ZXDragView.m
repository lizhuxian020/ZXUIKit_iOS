//
//  ZXDragView.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDragView.h"

@implementation ZXDragView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self addGestureRecognizer:recognizer];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self gestureStart:recognizer];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self gestureMove:recognizer];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        [self gestureEnd:recognizer];
    }
}

- (void)gestureStart:(UIGestureRecognizer *)recognizer {
    //开始抖动
    
    //目标cell消失
    //创建可移动的tempCell
    
}

- (void)gestureMove:(UIGestureRecognizer *)recognizer {
    
}

- (void)gestureEnd:(UIGestureRecognizer *)recognizer {
    //结束抖动
    //tempCell移动到目标位
    //目标cell复位
}

@end
