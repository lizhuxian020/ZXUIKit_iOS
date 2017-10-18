//
//  ZXDragView.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDragView.h"
#import "ZXDrayLayout.h"

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
@dynamic delegate;

#pragma mark --init
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self addGesture];
    }
    return self;
}

#pragma mark --gesture
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
    BOOL needReturn = false;
    
    needReturn = [self hasInHeaderView:point callback:^(NSIndexPath *indexPath) {
        _targetIndexPath = indexPath;
        
        //更新数据库
        [self updateDataSource];
        
        //做移动
        [UIView animateWithDuration:0.5 animations:^{
            [self moveItemAtIndexPath:_originIndexPath toIndexPath:_targetIndexPath];
        }];
        
        _originIndexPath = _targetIndexPath;
    }];
    
    if (needReturn) return;
    
    needReturn = [self hasInOtherCell:point callback:^(NSIndexPath *indexPath) {
        _targetIndexPath = indexPath;
        
        //更新数据库
        [self updateDataSource];
        
        //做移动
        [UIView animateWithDuration:0.5 animations:^{
            [self moveItemAtIndexPath:_originIndexPath toIndexPath:_targetIndexPath];
        }];
        
        _originIndexPath = _targetIndexPath;
    }];
    
    if (needReturn) return;
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
    NSMutableArray *arr = [self returnMutable:[self.dataSource dataSourceOfCollectionView:self]];
    
    if (_originIndexPath.section == _targetIndexPath.section) {
        NSMutableArray *sectionArr = [arr objectAtIndex:_originIndexPath.section];
        if (_originIndexPath.item > _targetIndexPath.item) {
            for (NSInteger i = _originIndexPath.item; i > _targetIndexPath.item; i--) {
                [sectionArr exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
        } else {
            for (NSInteger i = _originIndexPath.item; i < _targetIndexPath.item; i++) {
                [sectionArr exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
            }
        }
    } else {
        NSMutableArray *originSection = [arr objectAtIndex:_originIndexPath.section];
        NSMutableArray *targetSection = [arr objectAtIndex:_targetIndexPath.section];
        [targetSection insertObject:originSection[_originIndexPath.item] atIndex:_targetIndexPath.item];
        [originSection removeObjectAtIndex:_originIndexPath.item];
    }

    
    if ([self.delegate respondsToSelector:@selector(collectionView:updateDataSourceAfterMove:)]){
        [self.delegate collectionView:self updateDataSourceAfterMove:arr];
    }
}

- (BOOL)hasInOtherCell:(CGPoint)point callback:(void (^)(NSIndexPath *))callback {
    for (UICollectionViewCell *cell in self.visibleCells) {
        if ([self cellForItemAtIndexPath:_originIndexPath] == cell) continue;
        if (CGRectContainsPoint(cell.frame, point)) {
            callback([self indexPathForCell:cell]);
            return true;
        }
    }
    return false;
}



- (BOOL)hasInHeaderView:(CGPoint)point callback:(void (^)(NSIndexPath *))callback {
    NSArray *headerArr = [self visibleSupplementaryViewsOfKind:UICollectionElementKindSectionHeader];
    headerArr = [headerArr sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        if (obj1.zx_y > obj2.zx_y) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    for (NSInteger i = 0; i < headerArr.count; i++) {
        UIView *headerView = headerArr[i];
        if (CGRectContainsPoint(headerView.frame, point)) {
            NSInteger item = point.x / (kCellWidth + kItemSpace);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:i];
            if ([indexPath isEqual:_originIndexPath]) {
                return true;
            }
            callback(indexPath);
            return true;
        }
    }
    return false;
}

#pragma mark --

#pragma mark --utils

/**
 遍历array, 返回mutableArray
 */
- (NSMutableArray *)returnMutable:(NSArray *)array {
    NSMutableArray *mtArr = (NSMutableArray *)array;
    if (![array isKindOfClass:[NSMutableArray class]]) mtArr = array.mutableCopy;
    [mtArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = obj;
            if (![arr isKindOfClass:[NSMutableArray class]]) {
                arr = [arr mutableCopy];
                [mtArr replaceObjectAtIndex:idx withObject:arr];
            }
            NSMutableArray *sonMtArr = mtArr[idx];
            [mtArr replaceObjectAtIndex:idx withObject:[self returnMutable:sonMtArr]];
        }
    }];
    return mtArr;
}

@end
