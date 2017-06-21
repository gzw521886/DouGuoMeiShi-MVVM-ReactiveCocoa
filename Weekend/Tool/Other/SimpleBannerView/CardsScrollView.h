//
//  CardsScrollView.h
//  lunbo
//
//  Created by JiubaiMacMZG on 2017/6/13.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardsScrollView : UIScrollView

@property (nonatomic,strong) NSArray * cards;

/** 是否自动滑动, 默认为 NO */
@property (nonatomic, assign) BOOL autoScroll;

/** 自动滑动间隔时间(s), 默认为 3.0 */
@property (nonatomic, assign) CGFloat scrollInterval;

/** 是否需要循环滚动, 默认为 NO */
@property (nonatomic, assign) BOOL shouldLoop;

- (void)startTimer;
- (void)stopTimer;

- (void)reloadData;


/**
 初始化轮播图

 @param views    view数组
 @param interval 滑动间隔时间
 @return         轮播图
 */
+ (instancetype) bannerWithViews:(NSArray *)views scrollINterval:(CGFloat)interval frame:(CGRect)frame;

@end
