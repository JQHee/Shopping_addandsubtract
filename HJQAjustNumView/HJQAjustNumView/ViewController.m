//
//  ViewController.m
//  HJQAjustNumView
//
//  Created by HJQ on 2017/6/20.
//  Copyright © 2017年 HJQ. All rights reserved.
//

#import "ViewController.h"
#import "HJQAjustNumView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建对象
    HJQAjustNumView *btn = [[HJQAjustNumView alloc] init];
    
    // 设置Frame，如不设置则默认为(0, 0, 110, 30)
    btn.frame = CGRectMake(100, 300, 140, 40);
    // 内容更改的block回调
    btn.callBack = ^(NSString *currentNum, HJQOperationType type){
        NSLog(@"%@", currentNum);
    };
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
