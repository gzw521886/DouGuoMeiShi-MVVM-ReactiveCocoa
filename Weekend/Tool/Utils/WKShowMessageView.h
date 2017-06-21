//
//  WKShowMessageView.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKShowMessageView : NSObject


+ (void)showErrorWithMessage:(NSString *)message;


+ (void)showSuccessWithMessage:(NSString *)message;


+ (void)showStatusWithMessage:(NSString *)message;

+ (void)dismissSuccessView:(NSString *)message;
+ (void)dismissErrorView:(NSString *)message;
@end
