//
//  WKShowMessageView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/18.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKShowMessageView.h"
#import <MMProgressHUD.h>

@implementation WKShowMessageView

+ (void)showErrorWithMessage:(NSString *)message{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingRight];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStyleBordered];
    [MMProgressHUD dismissWithError:nil title:message afterDelay:2.0];
}

+(void)showSuccessWithMessage:(NSString *)message{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingRight];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStyleBordered];
    [MMProgressHUD dismissWithSuccess:nil title:message afterDelay:2.0];
}

+ (void)showStatusWithMessage:(NSString *)message{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:nil status:message];
}

+(void)dismissSuccessView:(NSString *)message{
    [MMProgressHUD dismissWithSuccess:message];
}

+(void)dismissErrorView:(NSString *)message{
     [MMProgressHUD dismissWithError:message];
}


@end
