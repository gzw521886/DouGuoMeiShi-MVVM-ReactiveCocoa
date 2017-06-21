//
//  WKHomebannerView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/6.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKHomebannerView.h"

@interface WKHomebannerView()
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) YYAnimatedImageView * bannerImage;  //banner背景图;

@property (nonatomic,weak) UILabel * dishesFeature;          //菜品特色
@property (nonatomic,strong) YYAnimatedImageView * userIcon; //用户头像
@property (nonatomic,weak) UILabel * userName;               //用户名称

@end

@implementation WKHomebannerView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
       
    }
    return self;
}

-(void)setBannerModel:(WHomebanner *)bannerModel{
    _bannerModel=bannerModel;
    WHomebanner * model=self.bannerModel;
    NSInteger type=model.h;
   
    [self setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.d.i]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
    
    //带用户消息
    if (type==0) {
        self.dishesFeature.text=model.d.t;
        [self.userIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.u.p]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
        self.userName.text=model.u.n;
    }

}


+(instancetype)getBannerViewWithModel:(WHomebanner *)bannerModel Frame:(CGRect)frame{
    WKHomebannerView * banner=[[WKHomebannerView alloc] initWithFrame:frame];
    banner.bannerModel=bannerModel;
    return banner;
}

#pragma  mark - getter

-(YYAnimatedImageView *)bannerImage{
    return WK_LJZ(_bannerImage, ({
        YYAnimatedImageView * backView=[YYAnimatedImageView new];
        backView.backgroundColor=[UIColor orangeColor];
        [self addSubview:backView];
        backView.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.height);
        backView;
    }));
   
}



-(UILabel *)dishesFeature{
    return WK_LJZ(_dishesFeature, ({
        UILabel * dfeature=[[UILabel alloc] init];
        dfeature.textAlignment=NSTextAlignmentCenter;
        [self.bannerImage addSubview:dfeature];
        [dfeature mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@30);
        }];
        dfeature.backgroundColor=[UIColor clearColor];
        dfeature.font=WKFONTBIGBIG;
        [dfeature setTextColor:[UIColor whiteColor]];
        dfeature;
    
    }));
}

-(UILabel *)userName{
    return WK_LJZ(_userName, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentLeft;
        [self.bannerImage addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-25);
            make.left.mas_equalTo(SCREEN_WIDTH/2-10);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            make.height.equalTo(@20);
        }];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTSMALL;
        [name setTextColor:[UIColor whiteColor]];
        name;
    }));
}

-(YYAnimatedImageView *)userIcon{
    return  WK_LJZ(_userIcon, ({
        YYAnimatedImageView * icon=[YYAnimatedImageView new];
        [self.bannerImage addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userName);
            make.right.mas_equalTo(-SCREEN_WIDTH/2-20);
            make.width.and.height.mas_equalTo(25);
        }];
        icon.layer.masksToBounds=YES;
        icon.layer.cornerRadius=15;
        icon;
    }));

}



@end
