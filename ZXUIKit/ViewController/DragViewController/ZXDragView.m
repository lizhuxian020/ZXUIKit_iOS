//
//  ZXDragView.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDragView.h"

@interface ZXDragView() {
    NSIndexPath *_originIndexPath;
    NSIndexPath *_targetIndexPath;
}

@property(nonatomic, strong) UILongPressGestureRecognizer *longPressRecognizer;

@property(nonatomic, strong) UICollectionViewCell *targetCell;

@property(nonatomic, strong) UIView *tempMoveCell;

@end

@implementation ZXDragView

@dynamic dataSource;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    recognizer.minimumPressDuration = 0.5f;
    _longPressRecognizer = recognizer;
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    _longPressRecognizer.enabled = [self indexPathForItemAtPoint:point];
    return [super hitTest:point withEvent:event];
}

- (void)gestureStart:(UIGestureRecognizer *)recognizer {
    //开始抖动
    
    _originIndexPath = [self indexPathForItemAtPoint:[recognizer locationInView:self]];
    _targetCell = [self cellForItemAtIndexPath: _originIndexPath];
    
    //创建可移动的tempCell
    UIView *tempCell = [self renderView:_targetCell];
    tempCell.zx_size = CGSizeMake(tempCell.zx_width + 10, tempCell.zx_height + 10);
    [self addSubview:tempCell];
    _tempMoveCell = tempCell;
    //目标cell消失
    _targetCell.hidden = true;
}

- (UIView *)renderView:(UIView *)view {
    UIImage *snap;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width - 1, view.bounds.size.height), 1.0f, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *tempView = [UIView new];
    tempView.layer.contents = (__bridge id)snap.CGImage;
    tempView.frame = view.frame;
    return tempView;
}

- (void)gestureMove:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    _tempMoveCell.center = point;
    
    [self hasInOtherCell:point callback:^(NSIndexPath *indexPath) {
        _targetIndexPath = indexPath;
        
        //更新数据库
        [self updateDataSource];
        
        //做移动
        [UIView animateWithDuration:0.5 animations:^{
            [self moveItemAtIndexPath:_originIndexPath toIndexPath:_targetIndexPath];
        }];
    }];
}

- (void)gestureEnd:(UIGestureRecognizer *)recognizer {
    //结束抖动
    _targetCell.hidden = NO;
    //tempCell移动到目标位
    [_tempMoveCell removeFromSuperview];
    _tempMoveCell = nil;
    _originIndexPath = nil;
    //目标cell复位
}

- (void)updateDataSource {
    NSMutableArray *arr = [self.dataSource dataSourceOfCollectionView:self].mutableCopy;
    NSArray *temp = @[@[@(12)], @[@[@"qwe"]], @[@"asd"]];
    [self flagMap:temp];
    NSLog(@"%@", temp);
}

- (void)hasInOtherCell:(CGPoint)point callback:(void (^)(NSIndexPath *))callback {
    for (UICollectionViewCell *cell in self.visibleCells) {
        if (CGRectContainsPoint(cell.frame, point)) {
            callback([self indexPathForCell:cell]);
            break;
        }
    }
}

- (void)flagMap:(NSArray *)array {
    if (![array isKindOfClass:[NSMutableArray class]]) array = array.mutableCopy;
    for (id obj in array) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)obj;
            if (![arr isKindOfClass:[NSMutableArray class]]) {
                arr = [arr mutableCopy];
            }
            [self flagMap:arr];
        }
    }
    
}

@end
