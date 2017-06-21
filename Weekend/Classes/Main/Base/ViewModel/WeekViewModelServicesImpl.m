//
//  WeekViewModelServicesImpl.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/31.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WeekViewModelServicesImpl.h"
#import "WeekHomeProtocolImpl.h"

@interface WeekViewModelServicesImpl()
//首页数据服务
@property (nonatomic,strong) WeekHomeProtocolImpl * homeService;
@end

@implementation WeekViewModelServicesImpl

- (instancetype)initModelServiceImpl{
    if (self = [super init]) {
        _homeService=[WeekHomeProtocolImpl new];
    }
    return self;
}

- (id<WKViewModelProtocolImpl>)getHomeService{
    return self.homeService;
}

@end
