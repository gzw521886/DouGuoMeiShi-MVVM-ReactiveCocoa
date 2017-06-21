//
//  WeekHomeProtocolImpl.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WeekHomeProtocolImpl.h"
#import "WeekHomeModel.h"


@interface WeekHomeProtocolImpl()

/**
 *  banner数组
 */
@property (nonatomic,strong) NSMutableArray * bannerData;

/**
 *  link数组
 */
@property (nonatomic,strong) NSMutableArray * linkData;


/**
 *  三餐推荐数组
 */
@property (nonatomic,strong) NSMutableArray * threeMeals;

/**
 * item数组
 */
@property (nonatomic,strong) NSMutableArray * itemData;

/**
 *  首页model数据
 */
@property (nonatomic,strong) NSMutableDictionary * HomeData;

@property (nonatomic,assign)NSInteger page;
@end


@implementation WeekHomeProtocolImpl

-(RACSignal *)requestHomeDataSignal:(NSString *)requestUrl{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:@"1556484",@"btmid",@"0",@"user_id", nil];
        WKURLSessionTask * task= [WKNetWorking postWithUrl:requestUrl refreshCache:NO params:params success:^(id response) {
            NSDictionary * responseDic=response;
            NSDictionary * dic=response;
    
            if (dic) {
                NSString * state=[dic objectForKey:@"state"];
                if ([state isEqualToString:@"success"]) {
                    NSDictionary * resultDic=[dic objectForKey:@"result"];
                    NSDictionary * headDic=[resultDic objectForKey:@"header"];
                    NSArray * listDics=[resultDic objectForKey:@"list"];
                    _page=1;
                    NSMutableArray * items=[NSMutableArray array];
                    for (int i=0; i<listDics.count; i++) {
                        NSDictionary * dic=listDics[i];
                        WHomeCellModel * banner=[WHomeCellModel modelWithDictionary:dic];
                        [items addObject:banner];
                    }
                    self.itemData=items;
                    
                    //banner
                    NSArray * bannerDics=[headDic objectForKey:@"dsps"];
                    NSMutableArray * banners=[NSMutableArray array];
                    for (int i=0; i<bannerDics.count; i++) {
                        NSDictionary * dic=bannerDics[i];
                        WHomebanner * banner=[WHomebanner modelWithDictionary:dic];
                        [banners addObject:banner];
                    }
                    self.bannerData=banners;
                    
                    //link数组
                    NSArray * linkDics=[headDic objectForKey:@"fs"];
                    NSMutableArray * links=[NSMutableArray array];
                    for (int i=0; i<linkDics.count; i++) {
                        NSDictionary * dic=linkDics[i];
                        WeekHomeTopClassifyModel * link=[WeekHomeTopClassifyModel modelWithDictionary:dic];
                        [links addObject:link];
                    }
                    self.linkData=links;
                    
                    
                    //三餐数组
                    NSArray * mealDics=[headDic objectForKey:@"ds"];
                    NSMutableArray * meals=[NSMutableArray array];
                    for (int i=0; i<mealDics.count; i++) {
                        NSDictionary * dic=mealDics[i];
                        WHomemeals * meal=[WHomemeals modelWithDictionary:dic];
                        [meals addObject:meal];
                    }
                    self.threeMeals=meals;
                    
                }
            }
            [self.HomeData setValue:self.bannerData forKey:WKHomeBannerKey];
            [self.HomeData setValue:self.linkData forKey:WKHomeLinkKey];
            [self.HomeData setValue:self.threeMeals forKey:WKHomeMealKey];
            [self.HomeData setValue:self.itemData forKey:WKHomeItemKey];

            [subscriber sendNext:self.HomeData];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendError:error];
        
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}

- (RACSignal *)requestHomeMoreDataSignal:(NSString *)requestUrl{
    
    requestUrl=[NSString stringWithFormat:@"/recipe/home/%ld/20/1567967",_page*20];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSDictionary * params=[NSDictionary dictionaryWithObjectsAndKeys:@"1556484",@"btmid",@"0",@"user_id", nil];
        
       
        WKURLSessionTask * task= [WKNetWorking postWithUrl:requestUrl refreshCache:NO params:params success:^(id response) {
            NSDictionary * dic=response;
            
            if (dic) {
                NSDictionary * resultDic=[dic objectForKey:@"result"];
                
                NSArray * listDics=[resultDic objectForKey:@"list"];
                _page+=1;
                
                for (int i=0; i<listDics.count; i++) {
                    NSDictionary * dic=listDics[i];
                    WHomeCellModel * banner=[WHomeCellModel modelWithDictionary:dic];
                    [self.itemData addObject:banner];
                }
                
                
            }
            [self.HomeData setValue:self.itemData forKey:WKHomeItemKey];
            
            [subscriber sendNext:self.HomeData];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendError:error];
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];


}


#pragma mark - get
-(NSMutableDictionary *)HomeData{
    return WK_LJZ(_HomeData, @{}.mutableCopy);
}



@end
