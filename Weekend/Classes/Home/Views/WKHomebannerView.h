//
//  WKHomebannerView.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/6.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WKHomebannerView : YYAnimatedImageView
@property (nonatomic,strong) WHomebanner * bannerModel;
+(instancetype)getBannerViewWithModel:(WHomebanner *)bannerModel Frame:(CGRect)frame;
@end
