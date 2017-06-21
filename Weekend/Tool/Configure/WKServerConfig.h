//
//  WKServerConfig.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKServerConfig : NSObject
// env: 环境参数 00:测试环境  01:生成环境
+ (void)setWKConfigEvn:(NSString *)value;

//返回环境参数  00：测试环境
+ (NSString *)WKConfigEvn;

//获取服务器地址
+ (NSString *)getWKServerAddr;

@end
