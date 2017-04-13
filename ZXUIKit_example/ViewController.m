//
//  ViewController.m
//  ZXUIKit_example
//
//  Created by lzx on 17/4/12.
//  Copyright © 2017年 lzx. All rights reserved.
//

#import "ViewController.h"
//#import "ZXButton.h"
#import "ZXUIKit.h"
#import <Masonry.h>
#import <ZXConvenientCode/ZXSugarCode.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZXButton *btn = [[ZXButton alloc] initWithTitle:@"" attribute:@{} color:nil type:ZXButtonType_Normal];
    [self.view addSubview:btn];
    [btn sizeToFit];
    btn.zx_width = 100;
    btn.zx_height = 80;
    btn.center = self.view.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
