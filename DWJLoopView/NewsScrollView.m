//
//  ADuScrollView.m
//  头条轮播demo
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#define SelfWidth  self.bounds.size.width
#define SelfHighth  self.bounds.size.height

#import "NewsScrollView.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@implementation NewsScrollView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
   
    return self;
}

- (void)loadAll{
    if (_pageControl) [_pageControl removeFromSuperview];
    
    _tagsArray = [[NSMutableArray alloc] init];//每张图片设置一个tag值，作为点击的标识
    _imagesArray  = [[NSMutableArray alloc] init];

    if (_newsAllDataArray.count == 0) {
        
        UIImageView *defaultImaV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_default"]];
        defaultImaV.frame = CGRectMake(0, 0, SelfWidth, SelfHighth);
        [self addSubview:defaultImaV];
        
        self.contentSize = CGSizeMake(SelfWidth, SelfHighth);
        self.contentOffset = CGPointMake(0, 0);
        _secondImgV.frame=CGRectMake(SelfWidth, 0,SelfWidth, SelfHighth);
        return;
    }
    
    for (int i = 0 ; i<_newsAllDataArray.count; i++) {
        NSString *tag = [NSString stringWithFormat:@"%d",i];
        [_tagsArray addObject:tag];
        NSString *imageUrl = [NSString  stringWithFormat:@"%@",[_newsAllDataArray objectAtIndex:i]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            [_imagesArray addObject:image];
        }else
        {
            [_imagesArray addObject:imageUrl];
        }
    }
    
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    [self addView];
    
    currentLabelInt = 0;
    if ([[_imagesArray lastObject] isKindOfClass:[NSString class]]) {
        [_firstImgV sd_setImageWithURL:[NSURL URLWithString:[_imagesArray lastObject]]];
    }else
    {
        _firstImgV.image = [_imagesArray lastObject];
    }
    
    if ([_imagesArray[0] isKindOfClass:[NSString class]]) {
        [_secondImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[0]]];
    }else
    {
        _secondImgV.image = _imagesArray[0];
    }
    
    if (_imagesArray.count > 1) {
        
        self.contentSize = CGSizeMake(SelfWidth*3, SelfHighth);
        self.contentOffset = CGPointMake(SelfWidth, 0);
        self.scrollEnabled = YES;
        
        if ([_imagesArray[1] isKindOfClass:[NSString class]]) {
            [_thirdImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[1]]];
        }else
        {
            _thirdImgV.image = _imagesArray[1];
        }
    
        [self timerStart];
        
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 100*SelfWidth/320-18*ScreenWidthScale, 16*_imagesArray.count, 16)];
        _pageControl.right  = SelfWidth-10*ScreenWidthScale;
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        _pageControl.currentPageIndicatorTintColor = RGB(246, 63, 63);
        _pageControl.pageIndicatorTintColor = RGB(157, 157, 157);
        _pageControl.numberOfPages = _imagesArray.count;
        _pageControl.currentPage = 0;
        _pageControl.defersCurrentPageDisplay=YES;
        [self.superview addSubview:_pageControl];
        _secondImgV.frame=CGRectMake(SelfWidth, 0,SelfWidth, SelfHighth);
    }else
    {
        self.contentSize = CGSizeMake(SelfWidth, SelfHighth);
        self.contentOffset = CGPointMake(0, 0);
        _secondImgV.frame=CGRectMake(0, 0,SelfWidth, SelfHighth);
        self.scrollEnabled = NO;//1张图片不动
        
        if ([_imagesArray[0] isKindOfClass:[NSString class]]) {
            [_thirdImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[0]]];
        }else
        {
            _thirdImgV.image = _imagesArray[0];
        }

    }
}
- (void)timerStop{
    [_timer invalidate];
    _timer = nil;
    [_thread cancel];
    _thread=nil;
}
- (void)timerStart{
    if (_imagesArray.count > 1) {
        if (!_thread) {
            _thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
            [_thread start];
        }
    }
    
}
-(void)newThread
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(threadMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

-(void)threadMethod
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setContentOffset:CGPointMake(SelfWidth*2,0) animated:YES];
        [NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(scroll) userInfo:nil repeats:NO];
    });
}
-(void)addView
{

    _firstImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SelfWidth, SelfHighth)];
    [self addSubview:_firstImgV];

    _secondImgV= [[UIImageView alloc] initWithFrame:CGRectMake(SelfWidth, 0,SelfWidth, SelfHighth)];
    _secondImgV.tag = [_tagsArray[0] integerValue];
    _secondImgV.userInteractionEnabled = YES;
    [self addSubview:_secondImgV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_secondImgV addGestureRecognizer:tap];
    
    _thirdImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SelfWidth *2, 0,SelfWidth, SelfHighth)];
    [self addSubview:_thirdImgV];

}

-(void)scroll{
    
    if ([_imagesArray count]>1) {
        currentLabelInt = (currentLabelInt + 1)%_imagesArray.count;
        if ([_imagesArray[(currentLabelInt-1)%_imagesArray.count] isKindOfClass:[NSString class]]) {
            [_firstImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[(currentLabelInt-1)%_imagesArray.count]]];
        }else
        {
            _firstImgV.image = _imagesArray[(currentLabelInt-1)%_imagesArray.count];
        }
        
        if ([_imagesArray[currentLabelInt] isKindOfClass:[NSString class]]) {
            [_secondImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[currentLabelInt]]];
        }else
        {
            _secondImgV.image = _imagesArray[currentLabelInt];
        }
        _secondImgV.tag = [_tagsArray[currentLabelInt] integerValue];
        
        if ([_imagesArray[(currentLabelInt+1)%_imagesArray.count] isKindOfClass:[NSString class]]) {
            [_thirdImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[(currentLabelInt+1)%_imagesArray.count]]];
        }else
        {
            _thirdImgV.image = _imagesArray[(currentLabelInt+1)%_imagesArray.count];
        }
        
        [self setContentOffset:CGPointMake(SelfWidth, 0)];
        
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (currentLabelInt + 1)%_imagesArray.count;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer setFireDate:[NSDate distantFuture]];
    
    UITableView *tab=(UITableView *)scrollView.superview.superview;
    tab.scrollEnabled=NO;//不让tableview下拉
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    UITableView *tab=(UITableView *)scrollView.superview.superview;
    tab.scrollEnabled=YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    
    if (scrollView.contentOffset.x == 0)
    {
        if (currentLabelInt == 0) {
            currentLabelInt = _imagesArray.count;//使不会出现负数
        }
        currentLabelInt = (currentLabelInt-1)%_imagesArray.count;
        
    }else if (scrollView.contentOffset.x == 2*SelfWidth)
    {
        currentLabelInt = (currentLabelInt + 1)%_imagesArray.count;
    }else
    {
        return;
    }
    
    if ([_imagesArray[(currentLabelInt-1)%_imagesArray.count] isKindOfClass:[NSString class]]) {
        [_firstImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[(currentLabelInt-1)%_imagesArray.count]]];
    }else
    {
        _firstImgV.image = _imagesArray[(currentLabelInt-1)%_imagesArray.count];
    }
    
    if ([_imagesArray[currentLabelInt] isKindOfClass:[NSString class]]) {
        [_secondImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[currentLabelInt]]];
    }else
    {
        _secondImgV.image = _imagesArray[currentLabelInt];
    }
    
    _secondImgV.tag = [_tagsArray[currentLabelInt] integerValue];
    
    if ([_imagesArray[(currentLabelInt+1)%_imagesArray.count] isKindOfClass:[NSString class]]) {
        [_thirdImgV sd_setImageWithURL:[NSURL URLWithString:_imagesArray[(currentLabelInt+1)%_imagesArray.count]]];
    }else
    {
        _thirdImgV.image = _imagesArray[(currentLabelInt+1)%_imagesArray.count];
    }

    [self setContentOffset:CGPointMake(SelfWidth, 0)];
    
    _pageControl.currentPage = currentLabelInt;


}
- (void)cancelTimer{
    
    if (_timer) {
        
        [_timer invalidate];
        
        _timer = nil;
        
    }
    
}
//点击回调
-(void)tap:(UIGestureRecognizer*)tap
{
    NSInteger tag = tap.view.tag;
    [self.lunBoDelegate NewsLunBoScrollViewDidSelectedWithTag:tag];
}

@end
