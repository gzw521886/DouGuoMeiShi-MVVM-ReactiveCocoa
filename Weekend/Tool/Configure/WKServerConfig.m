//
//  WKServerConfig.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKServerConfig.h"
static NSString * WKConfigEvn;
@implementation WKServerConfig

+ (void)setWKConfigEvn:(NSString *)value{
    WKConfigEvn=value;
}

+ (NSString *)WKConfigEvn{
    
    return WKConfigEvn;
}

+ (NSString *)getWKServerAddr{
    if ([WKConfigEvn isEqualToString:@"00"]) {
        return WKURL_Test;
    }else{
        return WKURL;
    }

}

@end
