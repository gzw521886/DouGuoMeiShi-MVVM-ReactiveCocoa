//
//  WKViewModelProtocolImpl.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WKViewModelProtocolImpl <NSObject>

- (RACSignal *)requestHomeDataSignal:(NSString *)requestUrl;

- (RACSignal *)requestHomeMoreDataSignal:(NSString *)requestUrl;

@end
