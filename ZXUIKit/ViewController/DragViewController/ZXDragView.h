//
//  ZXDragView.h
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXDragView;

@protocol ZXDragViewDataSource <UICollectionViewDataSource>

//用来解决pointer is missing nullability type什么鬼的警告
NS_ASSUME_NONNULL_BEGIN
@required
/**
 *  返回整个CollectionView的数据，必须实现，需根据数据进行移动后的数据重排
 */
- (NSArray *)dataSourceOfCollectionView:(ZXDragView *)collectionView;

@end

@protocol ZXDragViewDelegate <UICollectionViewDelegate>

@required
- (void)collectionView:(ZXDragView *)collectionView updateDataSourceAfterMove:(NSMutableArray *)dataSource;

@end
NS_ASSUME_NONNULL_END

@interface ZXDragView : UICollectionView

@property(nonatomic, assign) CGFloat timestamp;

@property (nonatomic, weak, nullable) id <ZXDragViewDataSource> dataSource;

@property (nonatomic, weak, nullable) id <ZXDragViewDelegate> delegate;

@end
