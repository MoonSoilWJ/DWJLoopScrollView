
//
//  Created by 杜文杰 on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoopSelectedDelegate <NSObject>
- (void)LoopScrollViewDidSelectedWithTag:(NSInteger)tag;
@end

@interface LoopScrollView : UIScrollView <UIScrollViewDelegate>
@property(nonatomic,retain) NSArray *imageDataArray;
@property(nonatomic,assign) id<LoopSelectedDelegate> loopDelegate;

- (void)loadAll;///加载数据
- (void)timerStop;///停止轮播的timer

@end
