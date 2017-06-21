//
//  WKViewModel.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/31.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKViewModel.h"

@interface WKViewModel ()

@property (strong, nonatomic ,readwrite) RACCommand * requestDataCommand;

@property (strong,nonatomic,readwrite) id<WeekViewModelService> services;
@end

@implementation WKViewModel

- (instancetype)initWithService:(id<WeekViewModelService>)service{
    if ([super init]) {
        self.services=service;
        @weakify(self);
        self.requestDataCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self executeRequestDataSignal:input];
        }];
    }
    [self initialize];
    return self;
}
- (void)initialize{};

- (RACSignal *)executeRequestDataSignal:(id)input{
    return [RACSignal empty];
}


@end
