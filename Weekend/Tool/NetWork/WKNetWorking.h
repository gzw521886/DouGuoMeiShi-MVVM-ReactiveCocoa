//
//  WKNetWorking.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/17.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  下载进度
 *
 *  bytesRead         已下载的大小
 *  totalBytesRead    文件总大小
 */
typedef void(^WKDownloadProgress)(int64_t bytesRead,int64_t totalBytesRead);
typedef  WKDownloadProgress  WKGetProgress;
typedef  WKDownloadProgress  WKPostProgress;

/**
 *  上传进度
 *  bytesWritten      已上传的大小
 *  totalBytesWritten 文件总大小
 **/
typedef void(WKUploadProgress)(int64_t bytesWritten,int64_t totalBytesWritten);

typedef NS_ENUM(NSUInteger,WKResponseType){
    WKResponseTypeJSON =1,
    WKResponseTypeXML  =2,
    WKResponseTypeData =3
};

typedef NS_ENUM(NSUInteger,WKRequestType){
    WKRequestTypeJSON      = 1,
    WKRequestTypePlainText =2
};

typedef NS_ENUM(NSInteger,WKNetworkStatus){
    WKNetworkStatusUnknown          =-1,  //未知网络
    WKNetworkStatusNotReachable     = 0,  //无网络链接
    WKNetworkStatusReachableViaWWAN = 1,  //2 3 4G
    WKNetworkStatusReachableViaWiFi = 2   //WIFI
};

/**
 * 所有接口返回值均为NSURLSessionTask
 **/
typedef NSURLSessionTask WKURLSessionTask;

/**
 * 请求成功回调
 **/
typedef void(^WKResponseSuccess)(id response);

/**
 * 请求失败回到
 **/
typedef void(^WKResponseError)(NSError * error);


@interface WKNetWorking : NSObject

+ (NSString *)encodeUrl:(NSString *)url;
+(WKURLSessionTask *)WK_requestWithUrl:(NSString *)url
                          refreshCache:(BOOL)refreshCache
                             isShowHUD:(BOOL)isShowHUD
                               showHUD:(NSString *)statusText
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                              progress:(WKDownloadProgress)progress
                               success:(WKResponseSuccess)success
                                  fail:(WKResponseError)fail;


/**
 *  接口URL
 **/
+ (void)updateBaseURL:(NSString *)baseURL;
+ (NSString *)baseUrl;

/**
 *  设置网络超请求超时时间
 **/
+ (void)setTimeout:(NSTimeInterval)timeout;

/**
 * 设置网络异常时从本地获取数据 
 * 默认为NO
 **/
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)sholdObtain;

/**
 * 设置请求时是否把数据缓存到本地
 * 默认是不缓存的
 **/
+ (void)chacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;


/**
 *  获取缓存的大小
 **/
+ (unsigned long long) totalCacheSize;

/**
 *  清除缓存
 **/
+ (void)clearCaches;


/**
 *  是否开启接口打印信息
 *  默认是NO
 **/
+ (void)enableInterfaceDebug:(BOOL)isDebug;

/**
 *  设置请求格式
 *  requestType   默认为JSON
 *  responseType  默认为json
 *  shouldAutoEncode 默认为NO 是否自动encode url
 *  shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 **/
+ (void)configRequestType:(WKRequestType)requestType
             responseType:(WKResponseType)resonseType
             shouldAutoEncodeURL:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;



/**
 *  配置公共的请求头，只调用一次即可
 *  httpHeaders
 **/
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;


/**
 *  取消所有请求
 **/
+ (void)cancelAllRequest;

/**
 *  取消某个请求
 *  url,可以是绝对URL 也可以是path
 **/
+ (void)cancelRequestWithURL:(NSString *)url;

/**************
 *  GET请求接口，若不指定baseurl,可以完整的URL
 *
 *  url             接口路径
 *  refreshCache    是否刷新缓存
 *  statusText      提示框文字
 *  params          接口中所需要的拼接参数
 *  success         成功请求道数据的回调
 *  fail            请求失败返回的数据
 *
 *  return          返回的对象中有可取消请求的API
 *************/

+ (WKURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                    success:(WKResponseSuccess)success
                    fail:(WKResponseError)fail;


/**
 *  get 有提示框
 **/
+ (WKURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                    showHUD:(NSString *)statusText
                    success:(WKResponseSuccess)success
                    fail:(WKResponseError)fail;





/**
 *  get有参数无提示框
 */
+ (WKURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                    params:(NSDictionary *)params
                    success:(WKResponseSuccess)success
                    fail:(WKResponseError)fail;


/**
 *  有参数有提示框
 */
+ (WKURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                    showHUD:(NSString *)statusText
                    params:(NSDictionary *)params
                    success:(WKResponseSuccess)success
                    fail:(WKResponseError)fail;


/**
 *  有进度回调 有参数
 */
+ (WKURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                     params:(NSDictionary *)params
                     progress:(WKGetProgress)progress
                     success:(WKResponseSuccess)success
                     fail:(WKResponseError)fail;


/**
 *  有进度回调 有参数 有提示框
 */
+ (WKURLSessionTask *)getWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                      showHUD:(NSString *)statusText
                      params:(NSDictionary *)params
                      progress:(WKGetProgress)progress
                      success:(WKResponseSuccess)success
                      fail:(WKResponseError)fail;


/**
 *  POST请求接口，若不指定baseurl,可传网址的URL
 *
 *  url 接口路径
 *  params 参数
 *  success 请求到数据的回调
 *  fail 请求数据失败回调
 *
 *  return 返回的对象中有可取消请求的API
 *
 **/
+ (WKURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                     params:(NSDictionary *)params
                     success:(WKResponseSuccess)success
                     fail:(WKResponseError)fail;

/**
 *  有提示框
 */
+ (WKURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                     showHUD:(NSString *)statusText
                     params:(NSDictionary *)params
                     success:(WKResponseSuccess)success
                     fail:(WKResponseError)fail;


/**
 *  有进度回调
 */
+ (WKURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                     params:(NSDictionary *)params
                     progress:(WKPostProgress)progress
                     success:(WKResponseSuccess)success
                     fail:(WKResponseError)fail;



/**
 *  有进度回调有提示框
 */
+ (WKURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                     showHUD:(NSString *)statusText
                     params:(NSDictionary *)params
                     progress:(WKPostProgress)progress
                     success:(WKResponseSuccess)success
                     fail:(WKResponseError)fail;


/**
 *  图片上传接口。若不指定baseurl,可以传完整url
 *
 *
 *  image       图片对象
 *  url         上传图片接口路径   如、/path/images/
 *  filename    图片名称 默认为当前日期 ‘yyyyMMddHHmmss’
 *  name        与指定的图片相关联的名称 ，这里是后端接口人员指定的，如imagefiles
 *  mineType    默认为image/jpeg
 *  parameters  参数
 *  progress    上传进度
 *  success     上传成功回调
 *  fail        上传失败回调
 *
 *  return
 *
 **/


+ (WKURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(WKUploadProgress)progress
                              success:(WKResponseSuccess)success
                                 fail:(WKResponseError)fail;


/**
 *  上传文件操作
 *  url             上传路径
 *  uploadingFile   待上传文件路径
 *  progress        上传进度
 *  success         上传成功回调
 *  fail            上传失败回调
 *
 *  return
 *
 ********/

+ (WKURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(WKUploadProgress)progress
                                success:(WKResponseSuccess)success
                                   fail:(WKResponseError)fail;


/**
 *  下载文件操作
 *  url             下载url
 *  saveToPath      下载到哪个路径下
 *  progressBlock   下载进度
 *  success         下载成功后的回调
 *  fail            下载失败后的回调
 *
 *  return
 *
 ********/
+ (WKURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(WKDownloadProgress)progressBlock
                              success:(WKResponseSuccess)success
                              failure:(WKResponseError)failure;
@end



















































