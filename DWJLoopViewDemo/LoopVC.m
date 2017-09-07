//
//  LoopVC.m
//  DWJLoopViewDemo
//
//  Created by 杜文杰 on 2017/9/7.
//  Copyright © 2017年 杜文杰. All rights reserved.
//

#import "LoopVC.h"
#import "LoopScrollView.h"

@interface LoopVC ()<LoopSelectedDelegate>
{
    LoopScrollView *_loopScrollView;
}
@end

@implementation LoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *imageUrlArray = @[
                               @"https://b-ssl.duitang.com/uploads/blog/201410/23/20141023231153_Z8JjB.thumb.700_0.jpeg",
                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504261974344&di=ea867d60ca3d3987698bd2a81928ba13&imgtype=0&src=http%3A%2F%2Fi3.sinaimg.cn%2Fent%2F2014%2F0305%2FU4611P28DT20140305111434.jpg",
                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504261974344&di=ef390b771cbf8717a3f686028ac0fe19&imgtype=0&src=http%3A%2F%2Fimg1.cache.netease.com%2Fcatchpic%2F4%2F49%2F49BB25E8825531BF326553D1B8492A3B.jpg",
                               @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504261974342&di=4b58de423b1b71efddf5d06573eaf12c&imgtype=0&src=http%3A%2F%2Fm1080.com%2Fupimg%2Fyxzp1%2F88920.jpg"];
    
    NSMutableArray *localImageUrlArr = [NSMutableArray arrayWithArray:imageUrlArray];
    for (int i = 0; i < 4; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"timg%d",i] ofType:@".jpg"];
        NSURL *url = [NSURL fileURLWithPath:path];
        [localImageUrlArr addObject:url];
    }
    
    
#pragma mark 接入
    _loopScrollView = [[LoopScrollView alloc] initWithFrame:CGRectMake(20, 70, self.view.bounds.size.width-40, 400)];
    _loopScrollView.imageDataArray = [localImageUrlArr copy];
    _loopScrollView.loopDelegate = self;
    _loopScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_loopScrollView];
    [_loopScrollView loadAll];
    
#warning pop出的时候 这个_looScrollView 不会释放 因为loopScrollView中的timer一直在运行，请调 -timerStop
    
    
    UIButton *popBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 50, 30)];
    popBtn.backgroundColor = [UIColor grayColor];
    [popBtn setTitle:@"pop" forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    
}

#pragma delegate
-(void)LoopScrollViewDidSelectedWithTag:(NSInteger)tag
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"你点击了第%zi个",tag] preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancelAction];
}

-(void)popVC
{
    [_loopScrollView timerStop];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
