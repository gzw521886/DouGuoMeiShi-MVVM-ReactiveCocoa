//
//  WKAppDotNetAPIClient.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface WKAppDotNetAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
