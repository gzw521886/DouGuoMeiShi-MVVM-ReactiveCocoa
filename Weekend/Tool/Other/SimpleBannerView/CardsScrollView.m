//
//  CardsScrollView.m
//  lunbo
//
//  Created by JiubaiMacMZG on 2017/6/13.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//
#define LUNBODURATION 0.3f
#import "CardsScrollView.h"
#import "UIImageView+ScrollBar.h"
@interface CardsScrollView()<UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *cardViewArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CardsScrollView
{
    NSInteger index;
    CGPoint originPoint;
    BOOL isleft;
    BOOL isright;
    
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
       
        self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.showsHorizontalScrollIndicator=YES;
        self.pagingEnabled=YES;
        self.alwaysBounceHorizontal=YES;
        self.delegate=self;
        self.tag=noDisableHorizontalScrollTag;
        [self flashScrollIndicators];
        self.autoScroll=YES;
        self.scrollIndicatorInsets=UIEdgeInsetsMake(0, -2, -3, -2);
       
        // 开启定时器
        [self startTimer];
    }
    return self;
}

+ (instancetype)bannerWithViews:(NSArray *)views scrollINterval:(CGFloat)interval frame:(CGRect)frame{
    CardsScrollView * scrollView=[[CardsScrollView alloc] initWithFrame:frame];
    scrollView.cards=views;
    scrollView.contentSize=CGSizeMake(frame.size.width*views.count, frame.size.height);
    if (interval&&interval>0) {
        scrollView.scrollInterval=interval;
    }else{
        scrollView.scrollInterval=10000;
    }
    if (views&&views.count>1) {
        scrollView.shouldLoop=YES;
    }else{
        scrollView.shouldLoop=NO;
    }
    [scrollView startTimer];
    return scrollView;
}

-(void)reloadData{
    [self startTimer];
}


#pragma mark - NSTimer

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    if (!self.autoScroll) return;
    if (!self.shouldLoop) return;
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 定时器方法
- (void)autoScrollToNextItem
{
    CGFloat offSetX=self.contentOffset.x;
    
    [UIView animateWithDuration:0.4 animations:^{
        [self setContentOffset:CGPointMake(self.width+offSetX, 0)];
        CGFloat  xx=self.contentOffset.x;
        int a=ABS(floor(xx/self.width));
        if (a<_cardViewArray.count) {
            UIView * gragView=_cardViewArray[a];
            gragView.left=xx*0.5+self.width*0.5*(a);
        }else{
            [self setContentOffset:CGPointMake(0, 0)];
            xx=0;
            a=0;
            UIView * gragView=_cardViewArray[a];
            gragView.left=xx*0.5+self.width*0.5*(a);
        }

    }];
    
}



- (void)setCards:(NSArray *)cards{
    _cards=cards;
    if (_cardViewArray ==nil) {
        _cardViewArray=[[NSMutableArray alloc]initWithCapacity:5];
        for (int i=0; i<cards.count; i++) {
            
            UIView * card=cards[i];
            if (i==0) {
                card.frame=CGRectMake(0,0, self.width, self.height);
            }else{
                card.frame=CGRectMake(self.width*0.5, 0, self.width, self.height);
            }
             [self insertSubview:card atIndex:0];
            [_cardViewArray addObject:card];

        }
       
    }
 
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat  xx=scrollView.contentOffset.x;
    int a=ABS(floor(xx/self.width));
    if (a<_cardViewArray.count-1&&_cardViewArray.count>0) {
        UIView * gragView=_cardViewArray[a+1];
        gragView.left=xx*0.5+self.width*0.5*(a+1);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 用户滑动的时候停止定时器
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 用户停止滑动的时候开启定时器
    [self startTimer];
}



#pragma mark - getter

/**
 *  自动滑动间隔时间
 */

- (void)setScrollInterval:(CGFloat)scrollInterval{
    _scrollInterval=scrollInterval;
    
    
    [self startTimer];
}


- (void)setShouldLoop:(BOOL)shouldLoop{
    _shouldLoop=shouldLoop;
}






@end

