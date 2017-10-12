//
//  ZXDragViewController.m
//  ZXUIKit_example
//
//  Created by lzx on 2017/10/10.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ZXDragViewController.h"
#import "ZXDrayLayout.h"
#import "DragCellModel.h"
#import "ZXDragView.h"
#import "ZXDragViewCell.h"

@interface ZXDragViewController ()<ZXDragViewDataSource, ZXDragViewDelegate>

@property(nonatomic, strong) ZXDragView *collectionView;

@property(nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZXDragViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerIdentifier = @"header";

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildDataSource];
        [self loadCollectionView];
        [self viewConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Do any additional setup after loading the view.
}

- (void)loadCollectionView {
    self.collectionView = [[ZXDragView alloc] initWithFrame:self.view.bounds collectionViewLayout:[ZXDrayLayout new]];
    // Register cell classes
    [self.collectionView registerClass:[ZXDragViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewConfig {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = true;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)buildDataSource {
    NSMutableArray *datasource = @[@[].mutableCopy, @[].mutableCopy, @[].mutableCopy].mutableCopy;
    for (NSInteger i = 0; i < datasource.count; i ++) {
        NSMutableArray *section = datasource[i];
        for (NSInteger j = 0; j < 8; j ++) {
            NSString *title = [NSString stringWithFormat:@"item%ld-%ld", (long)i, (long)j];
            UIColor *color = nil;
            if (i == 0) color = UIColor.redColor;
            else if (i == 1) color = UIColor.blueColor;
            else if (i == 2) color = UIColor.brownColor;
            else color = UIColor.cyanColor;
            DragCellModel *model = [DragCellModel modelWithTitle:title gbColor:color];
            [section addObject:model];
        }
    }
    self.dataSource = datasource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <ZXDragViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXDragViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DragCellModel *model = self.dataSource[indexPath.section][indexPath.item];
    cell.data = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    view.backgroundColor = UIColor.yellowColor;
    
    return view;
}

- (NSArray *)dataSourceOfCollectionView:(ZXDragView *)collectionView {
    return self.dataSource;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(ZXDragView *)collectionView updateDataSourceAfterMove:(NSMutableArray *)dataSource {
    self.dataSource = dataSource;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
