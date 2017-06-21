//
//  WKHomeViewModel.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/31.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKHomeViewModel.h"

@implementation WKHomeViewModel

- (instancetype)initWithService:(id<WeekViewModelService>)service{
    
    if (self = [super initWithService:service]) {
        _bannerData=[NSMutableArray new];
        _itemData =[NSMutableArray new];
        _linkData =[NSMutableArray new];
        _threeMeals=[NSMutableArray new];
        return self;
    }
    return self;
}

- (void)initialize{
    [super initialize];
    
    _requestMoreDataCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[self.services getHomeService] requestHomeMoreDataSignal:WKURL_HOMEDATA] doNext:^(id result) {
            self.itemData=result[WKHomeItemKey];
        }];
    }];
    
}
-(RACSignal *)executeRequestDataSignal:(id)input{

    return [[[self.services getHomeService] requestHomeDataSignal:WKURL_HOMEDATA] doNext:^(id result) {
        
        self.bannerData=result[WKHomeBannerKey];
        self.linkData  =result[WKHomeLinkKey];
        self.threeMeals=result[WKHomeMealKey];
        self.itemData  =result[WKHomeItemKey];

    }];

}

@end
