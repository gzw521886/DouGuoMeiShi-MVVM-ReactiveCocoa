//
//  WKHomeViewModel.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/31.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKViewModel.h"

@interface WKHomeViewModel : WKViewModel

/**
 *  首页请求更多数据
 */
@property (nonatomic,strong) RACCommand * requestMoreDataCommand;

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

@end
