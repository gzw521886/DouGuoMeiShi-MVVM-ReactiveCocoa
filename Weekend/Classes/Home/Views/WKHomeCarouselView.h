//
//  WKHomeCarouselView.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/5.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKHomeCarouselView : UIView

@property (strong, nonatomic) RACSignal *imageURLSignal;

@property (strong,nonatomic) RACSignal * linkSignal;

@property (strong,nonatomic) RACSignal * mealSignal;
@end
