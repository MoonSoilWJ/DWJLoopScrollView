//
//  ViewController.m
//  DWJLoopViewDemo
//
//  Created by 杜文杰 on 2017/9/1.
//  Copyright © 2017年 杜文杰. All rights reserved.
//

#import "ViewController.h"
#import "LoopVC.h"


@interface ViewController ()

@end

@implementation ViewController
- (IBAction)push:(id)sender {

    LoopVC *vc = [[LoopVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
