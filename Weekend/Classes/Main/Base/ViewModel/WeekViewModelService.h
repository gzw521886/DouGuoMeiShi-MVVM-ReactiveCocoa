//
//  WeekViewModelService.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/31.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKViewModelProtocolImpl.h"

@protocol WeekViewModelService <NSObject>

//获取首页数据
- (id<WKViewModelProtocolImpl>) getHomeService;




@end
