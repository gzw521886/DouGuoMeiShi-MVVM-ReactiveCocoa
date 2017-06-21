//
//  WKAppDotNetAPIClient.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKAppDotNetAPIClient.h"

@implementation WKAppDotNetAPIClient

+ (instancetype)sharedClient{
    static WKAppDotNetAPIClient * sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient=[[WKAppDotNetAPIClient alloc] init];
        sharedClient.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
     
        NSArray * keys=@[@"User-Agent",@"ifa",@"lon",@"channel",@"imei",@"client",@"resolution",@"version",@"newbie",@"Content-Length",@"cid",@"mac",@"lat",@"device",@"sdk"];
        
        NSArray * values=@[@"DouguoRecipes6/6.5.0 (iPhone; iOS 10.3.2; Scale/3.00)",@"044E47D7-DAC0-40AE-A338-36AC4C9BE529",@"125.269212",@"App Store",@"DFAA5BBF-7800-45A6-AFC0-4D33EC463C29",@"3",@"1125*2001",@"650",@"0",@"23",@"220100",@"02:00:00:00:00:00",@"43.814220",@"iPhone7,1",@"10.3.2"];
        
        for (int i=0; i<keys.count; i++) {
            [sharedClient.requestSerializer setValue:values[i] forHTTPHeaderField:keys[i]];
        }
        
        
    });
    
    return sharedClient;
}
@end
