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
    
    
    ZXButton *btn = [[ZXButton alloc] initWithTitle:@"" attribute:@{} color:[UIColor zx_colorWithHexString:@"#f13a28"] type:ZXButtonType_Rectangle];
    [self.view addSubview:btn];
    [btn sizeToFit];
    CGRect frame = btn.frame;
    frame.size.width += 100;
    btn.frame = frame;
    btn.center = self.view.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
