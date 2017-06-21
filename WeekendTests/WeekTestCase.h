//
//  WeekTestCase.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/23.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WeekTestCase : XCTestCase

@property (nonatomic,strong,readonly) NSString * url;

@property (nonatomic,assign,readonly) int  refreshCache;

@property (nonatomic,assign,readonly) int isShowHUD;

@property (nonatomic,strong,readonly) NSString * statusText;

@property (nonatomic,assign,readonly) NSUInteger * httpMethod;

@property (nonatomic,strong,readonly) NSDictionary * params;

//首页加载更多
@property (nonatomic,strong,readonly) NSString * moreUrl;

@end
