//
//  WKNetWorking.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/17.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKNetWorking.h"
#import <AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"
#import "WKAppDotNetAPIClient.h"

#import "WKServerConfig.h"
#import "WKShowMessageView.h"

/**
 *  基础URL
 */
static NSString * WK_privateNetworkBaseUrl = nil;

/**
 *  是否开启接口打印信息
 */
static BOOL WK_isEnableInterfaceDebug =NO;

/**
 *  是否开启自动转换URL里的中文
 */
static BOOL WK_showldAutoEncode = NO;

/**
 *  设置请求头默认为空
 */
static NSDictionary * WK_httpHeaders=nil;

/**
 *  设置返回数据类型
 */
static WKResponseType WK_responseType = WKResponseTypeData;

/**
 *  设置请求数据类型
 */
static WKRequestType WK_requestType = WKRequestTypePlainText;

/**
 *  监听网络状态
 */
static WKNetworkStatus WK_networkStatus = WKNetworkStatusUnknown;

/**
 *  保存所有网络请求的task
 */
static NSMutableArray * WK_requestTasks;

/**
 *  设置get和Post请求不缓存
 */
static BOOL WK_cacheGet = NO;
static BOOL WK_cachePost=NO;

/**
 * 是否开启取消请求
 */
static BOOL WK_shouldCallbackOnCancelRequest = YES;

/**
 * 请求的超时时间
 */
static NSTimeInterval WK_timeout = 25.0f;


/**
 *  是否从本地提取数据
 */
static BOOL WK_shouldObtainLocalWhenUnconnected = NO;

/**
 *  基础url是否更改 默认为yes
 */
static BOOL WK_isBaseURLChanged = YES;

/**
 *  请求管理者
 */
static WKAppDotNetAPIClient * WK_sharedManager = nil;


@implementation WKNetWorking
+(void)chacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost{
    WK_cacheGet=isCacheGet;
    WK_cachePost=shouldCachePost;
}

+ (void)updateBaseURL:(NSString *)baseURL{
    if ([baseURL isEqualToString:WK_privateNetworkBaseUrl]&&baseURL&&baseURL.length) {
        WK_isBaseURLChanged=YES;
    }else{
        WK_isBaseURLChanged=NO;
    }
    WK_privateNetworkBaseUrl=baseURL;
}

+ (NSString *)baseUrl{
    return WK_privateNetworkBaseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout{
    WK_timeout=timeout;
}

+(void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)sholdObtain{
    WK_shouldObtainLocalWhenUnconnected=sholdObtain;
}

+(void)enableInterfaceDebug:(BOOL)isDebug{
    WK_isEnableInterfaceDebug= isDebug;
}


+ (BOOL)isDebug{

    return WK_isEnableInterfaceDebug;
}

+ (NSMutableArray *)allTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (WK_requestTasks == nil) {
            WK_requestTasks=@[].mutableCopy;
        }
    });
    return WK_requestTasks;

}

UIKIT_STATIC_INLINE NSString * cachePath(){

    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WKNetworkingCaches"];
}

+ (void)clearCaches{
    NSString * directoryPath=cachePath();
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError * error=nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        if (error) {
            NSLog(@"清除缓存失败:[%@]",error);
        }else{
            NSLog(@"缓存清理成功");
        }
    }
}

+(unsigned long long)totalCacheSize{
    NSString * directoryPath =cachePath();
    BOOL isDir=NO;
    unsigned long long total = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError * error = nil;
            NSArray * array=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            if (error==nil) {
                for (NSString * subPath in array) {
                    NSString * path =[directoryPath stringByAppendingPathComponent:subPath];
                    
                    NSDictionary * dict=[[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
                    
                    if (!error) {
                        total+=[dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
            
        }
    }
    return total;
}

+ (void)cancelAllRequest{
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WKURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[WKURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url{
    if (url==nil) {
        return;
    }
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(WKURLSessionTask *  _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[WKURLSessionTask class]]&&[task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+(void)configRequestType:(WKRequestType)requestType responseType:(WKResponseType)resonseType shouldAutoEncodeURL:(BOOL)shouldAutoEncode callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest{
    WK_requestType=requestType;
    WK_responseType=resonseType;
    WK_showldAutoEncode=shouldAutoEncode;
    WK_shouldCallbackOnCancelRequest=shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode{
    return WK_showldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders{
    WK_httpHeaders=httpHeaders;
}

//无回调无提示框
+ (WKURLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:NO
                           showHUD:nil
                         httpMedth:1
                            params:nil
                          progress:nil
                           success:success
                              fail:fail];

}
//无进度回调 有提示框
+(WKURLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:YES
                           showHUD:statusText
                         httpMedth:1
                            params:nil
                          progress:nil
                           success:success
                              fail:fail];

}


//有参数 无进度回调 无提示框
+(WKURLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:NO
                           showHUD:nil
                         httpMedth:1
                            params:params
                          progress:nil
                           success:success
                              fail:fail];

}

// 有参数 无进度回调 有提示框
+ (WKURLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:YES
                           showHUD:statusText
                         httpMedth:1
                            params:params
                          progress:nil
                           success:success
                              fail:fail];

}


//有参数 有进度回调 无提示框
+(WKURLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params progress:(WKGetProgress)progress success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:NO
                           showHUD:nil
                         httpMedth:1
                            params:params
                          progress:progress
                           success:success
                              fail:fail];

}


//有参数 有进度回调 有提示框
+(WKURLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params progress:(WKGetProgress)progress success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:YES
                           showHUD:statusText
                         httpMedth:1
                            params:params
                          progress:progress
                           success:success
                              fail:fail];


}


//无进度 无提示框
+ (WKURLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:NO
                           showHUD:nil
                         httpMedth:2
                            params:params
                          progress:nil
                           success:success
                              fail:fail];

}

//无进度回调  有提示框
+ (WKURLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:YES
                           showHUD:statusText
                         httpMedth:2
                            params:params
                          progress:nil
                           success:success
                              fail:fail];

}


//有进度回调 无提示框
+ (WKURLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params progress:(WKPostProgress)progress success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:NO
                           showHUD:nil
                         httpMedth:2
                            params:params
                          progress:progress
                           success:success
                              fail:fail];
}

//有进度回调 有提示框
+ (WKURLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params progress:(WKPostProgress)progress success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    return [self WK_requestWithUrl:url
                      refreshCache:refreshCache
                         isShowHUD:YES
                           showHUD:statusText
                         httpMedth:2
                            params:params
                          progress:progress
                           success:success
                              fail:fail];
}


+(WKURLSessionTask *)uploadWithImage:(UIImage *)image url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters progress:(WKUploadProgress)progress success:(WKResponseSuccess)success fail:(WKResponseError)fail{

    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            return nil;
        }
    }else{
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            
            return nil;
        }
    
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    WKAppDotNetAPIClient * manager = [self manager];
    WKURLSessionTask * session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString * imageFileName = filename;
        if (filename ==nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString * str=[formatter stringFromDate:[NSDate date]];
            imageFileName=[NSString stringWithFormat:@"%@.jpg",str];
            
        }
        
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject url:absolute params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}


+(WKURLSessionTask *)uploadFileWithUrl:(NSString *)url uploadingFile:(NSString *)uploadingFile progress:(WKUploadProgress)progress success:(WKResponseSuccess)success fail:(WKResponseError)fail{
    if ([NSURL URLWithString:uploadingFile]== nil) {
        return nil;
    }
    
    NSURL * uploadURL=nil;
    
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil) {
        
        return nil;
    }
    
    WKAppDotNetAPIClient * manager=[self manager];
    NSURLRequest * request=[NSURLRequest requestWithURL:uploadURL];
    WKURLSessionTask * session=nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
        }else{
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:response.URL.absoluteString params:nil];
            }
        
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;

}


+(WKURLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath progress:(WKDownloadProgress)progressBlock success:(WKResponseSuccess)success failure:(WKResponseError)failure{
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            
            return nil;
        }
    }
    
    NSURLRequest * downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    WKAppDotNetAPIClient * manager = [self manager];
    
    WKURLSessionTask * sessions=nil;
    sessions=[manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:sessions];
        
        if (error ==nil) {
            if (success) {
                success(filePath.absoluteString);
            }
            
            if ([self isDebug]) {
                NSLog(@"下载成功地址%@",[self absoluteUrlWithPath:url]);
            }
        }else{
            [self handleCallbackWithError:error fail:failure];
            
            if ([self isDebug]) {
                NSLog(@"下载失败地址%@ 原因%@",[self absoluteUrlWithPath:url],[error description]);
            }
        
        }
        
    }];
    if (sessions) {
        [[self allTasks] addObject:sessions];
    }
    return sessions;
}



+(WKURLSessionTask *)WK_requestWithUrl:(NSString *)url
                          refreshCache:(BOOL)refreshCache
                             isShowHUD:(BOOL)isShowHUD
                               showHUD:(NSString *)statusText
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                              progress:(WKDownloadProgress)progress
                               success:(WKResponseSuccess)success
                                  fail:(WKResponseError)fail{

    if (url) {
        if ([url hasPrefix:@"http://"]||[url hasPrefix:@"https://"]) {
            
        }else{
            NSString * serverAddress=[WKServerConfig getWKServerAddr];
            url=[serverAddress stringByAppendingString:url];
        
        }
    }else{return nil;};
    
    if ([self shouldEncode]) {
        url=[self encodeUrl:url];
    }
    WKAppDotNetAPIClient * manager=[self manager];
    NSString * absolute=[self absoluteUrlWithPath:url];
    
    WKURLSessionTask * session = nil;
    if(isShowHUD){
        [WKNetWorking showHUD:statusText];
    }
    if (httpMethod == 1) {
        if (WK_cacheGet) {
            if (WK_shouldObtainLocalWhenUnconnected) {
                if (WK_networkStatus == WKNetworkStatusNotReachable || WK_networkStatus ==WKNetworkStatusUnknown) {
                    id response = [WKNetWorking cahceResponseWithURL:absolute parameters:params];
                    
                    if(response){
                        if(success){
                            [self successResponse:response callback:success];
                            
                            
                            if([self isDebug]){
                                [self logWithSuccessResponse:response url:absolute params:params];
                            }
                        }
                        
                        return nil;
                    }
                }
            }
            if(!refreshCache){
                id response=[WKNetWorking cahceResponseWithURL:absolute parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        if([self isDebug]){
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                    return nil;
                }
            
            }
            
        }
        
        session =[manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isShowHUD) {
                [WKNetWorking dismissSuccessHUD];
            }
            [[self allTasks] removeObject:task];
            [self successResponse:responseObject callback:success];
            if (WK_cacheGet) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            if([self isDebug]){
                [self logWithSuccessResponse:responseObject url:absolute params:params];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(isShowHUD){
                [WKNetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            
            if ([error code]<0 &&WK_cacheGet) {//获取缓存
                id response =[WKNetWorking cahceResponseWithURL:absolute parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                }else{
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            }else{
                [self handleCallbackWithError:error fail:fail];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
            
        }];
    }
    
    else if (httpMethod==2){
        if (WK_cachePost) {//获取缓存
            if (WK_shouldObtainLocalWhenUnconnected) {
                if (WK_networkStatus == WKNetworkStatusNotReachable || WK_networkStatus == WKNetworkStatusUnknown) {
                    id response=[WKNetWorking cahceResponseWithURL:absolute parameters:params];
                    
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response url:absolute params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response =[WKNetWorking cahceResponseWithURL:absolute parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if([self isDebug]){
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        
        NSArray * keys=@[@"User-Agent",@"ifa",@"lon",@"channel",@"imei",@"client",@"resolution",@"version",@"newbie",@"Content-Length",@"cid",@"mac",@"lat",@"device",@"sdk"];
        
        NSArray * values=@[@"DouguoRecipes6/6.5.0 (iPhone; iOS 10.3.2; Scale/3.00)",@"044E47D7-DAC0-40AE-A338-36AC4C9BE529",@"125.269212",@"App Store",@"DFAA5BBF-7800-45A6-AFC0-4D33EC463C29",@"3",@"1125*2001",@"650",@"0",@"23",@"220100",@"02:00:00:00:00:00",@"43.814220",@"iPhone7,1",@"10.3.2"];
        
        for (int i=0; i<keys.count; i++) {
            [manager.requestSerializer setValue:values[i] forHTTPHeaderField:keys[i]];
        }
        
        
        
        session =[manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShowHUD) {
                [WKNetWorking dismissSuccessHUD];
            }
            [[self allTasks] removeObject:task];
            [self successResponse:responseObject callback:success];
            
            if (WK_cachePost) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject url:absolute params:params];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (isShowHUD) {
                [WKNetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            if ([error code] <0&&WK_cachePost) {
                id response = [WKNetWorking cahceResponseWithURL:absolute parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response url:absolute params:params];
                        }
                    }
                }else{
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            }else{
                [self handleCallbackWithError:error fail:fail];
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
    
}




#pragma mark - Private
+ (WKAppDotNetAPIClient *)manager {
    
    @synchronized (self) {
        
        if (WK_sharedManager == nil || WK_isBaseURLChanged) {
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            WKAppDotNetAPIClient *manager = nil;;
            if ([self baseUrl] != nil) {
                manager = [[WKAppDotNetAPIClient sharedClient] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
            } else {
                manager = [WKAppDotNetAPIClient sharedClient];
            }
            
            switch (WK_requestType) {
                case WKRequestTypeJSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case WKRequestTypePlainText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            switch (WK_responseType) {
                case WKResponseTypeJSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case WKResponseTypeXML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case WKResponseTypeData: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            
            for (NSString *key in WK_httpHeaders.allKeys) {
                if (WK_httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:WK_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            // 设置cookie
            //            [self setUpCoookie];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            manager.requestSerializer.timeoutInterval = WK_timeout;
            
            manager.operationQueue.maxConcurrentOperationCount = 3;
            WK_sharedManager = manager;
        }
    }
    
    return WK_sharedManager;
}

+ (NSString *)encodeUrl:(NSString *)url{

    return [self WK_URLEncode:url];
}


+ (NSString *)WK_URLEncode:(NSString *)url{
    if ([url respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        static NSString * const kAFCharacterHTeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharacterHTeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < url.length) {
            NSUInteger length = MIN(url.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [url rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [url substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;

    }else{
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)url,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
    }
    return nil;
}



+ (NSString *)absoluteUrlWithPath:(NSString *)path{
    if (path ==nil || path.length==0) {
        return @"";
    }
    
    if ([self baseUrl] == nil ||[[self baseUrl] length]==0) {
        return path;
    }
    
    NSString * absoluteUrl = path;
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        }else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    
    return absoluteUrl;
}





+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

// 解析json数据
+ (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

+ (void)successResponse:(id)responseData callback:(WKResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}
    

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"\n");
    NSLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
          [self generateGETAbsoluteURL:url params:params],
          params,
          [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    NSLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        NSLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params);
    } else {
        NSLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params,
              [error localizedDescription]);
    }
}


+ (void)handleCallbackWithError:(NSError *)error fail:(WKResponseError)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (WK_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                NSLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                NSLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params{
    id cacheData =nil;
    
    if (url) {
        NSString * directoryPath  = cachePath();
        NSString * absoluteURL    = [self generateGETAbsoluteURL:url params:params];
        NSString * key            = [absoluteURL md5String];
        NSString * path           = [directoryPath stringByAppendingPathComponent:key];
        
        NSData * data =[[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            NSLog(@"读取数据缓存从：%@\n",url);
        }
        
    }
    return cacheData;
}

#pragma mark - HUD

+ (void)showHUD:(NSString *)showMessge
{
    
    
    dispatch_main_async_safe(^{
        [WKShowMessageView showStatusWithMessage:showMessge];
    });
}

+ (void)dismissSuccessHUD
{
    dispatch_main_async_safe(^{
        [WKShowMessageView dismissSuccessView:@"Success"];
    });
    
}
+ (void)dismissErrorHUD
{
    dispatch_main_async_safe(^{
        [WKShowMessageView dismissErrorView:@"Error"];
    });
    
}





@end






































