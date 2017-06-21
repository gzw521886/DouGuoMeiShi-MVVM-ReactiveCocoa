//
//  WKMealItemView.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/7.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKMealItemView : YYAnimatedImageView
@property (nonatomic,strong)RACSignal * mealItemSignal;
@property (nonatomic,strong)RACSignal * animationSignal;
@end
