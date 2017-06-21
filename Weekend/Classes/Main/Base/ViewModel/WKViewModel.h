//
//  WKViewModel.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/31.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekViewModelService.h"
@interface WKViewModel : NSObject

//首页数据请求
@property (strong, nonatomic ,readonly) RACCommand * requestDataCommand;



//viewModel
@property (strong,nonatomic,readonly) id<WeekViewModelService> services;

- (instancetype) initWithService:(id<WeekViewModelService>)service;

- (void)initialize;

- (RACSignal *)executeRequestDataSignal:(id)input;
@end
