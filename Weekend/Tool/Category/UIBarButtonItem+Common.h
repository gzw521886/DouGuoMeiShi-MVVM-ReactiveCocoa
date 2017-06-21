//
//  UIBarButtonItem+Common.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image selectImage:(NSString *)selectImage;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title;
@end
