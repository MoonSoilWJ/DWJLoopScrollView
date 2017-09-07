//
//  ADuScrollView.h
//  头条轮播demo
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewsLunBoSelectedDelegate <NSObject>

- (void)NewsLunBoScrollViewDidSelectedWithTag:(NSInteger)tag;

@end
@interface NewsScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *_firstImgV;
    UIImageView *_secondImgV;
    UIImageView *_thirdImgV;
    
//    UILabel *_firstLab;
//    UILabel *_secondLab;
//    UILabel *_thirdLab;
    
    NSTimer *_timer;
    
    NSUInteger currentLabelInt;
    
    NSMutableArray *_tagsArray;
    NSMutableArray *_imagesArray;
//    NSMutableArray *_titlesArray;
    
    UIPageControl *_pageControl;
    
}

@property(nonatomic,retain) NSMutableArray *newsAllDataArray;
@property(nonatomic,retain) NSThread *thread;

@property(nonatomic,retain) id<NewsLunBoSelectedDelegate> lunBoDelegate;

- (void)loadAll;
- (void)timerStop;
- (void)timerStart;

@end
