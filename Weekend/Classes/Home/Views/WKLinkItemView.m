//
//  WKLinkItemView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/7.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKLinkItemView.h"

@interface WKLinkItemView()
@property (nonatomic,weak,readwrite) YYAnimatedImageView * image;
@property (nonatomic,weak,readwrite) UILabel * title;
@end

@implementation WKLinkItemView

-(void)setItemSignal:(RACSignal *)itemSignal{
    _itemSignal=itemSignal;
    [itemSignal subscribeNext:^(WeekHomeTopClassifyModel * model) {
       
        [self.image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.i]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
        self.title.text=model.t;
        
    }];

}

-(YYAnimatedImageView *)image{
  return  WK_LJZ(_image, ({
        YYAnimatedImageView * icon=[YYAnimatedImageView new];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-self.height*0.5);
            make.width.and.height.mas_equalTo(35);
        }];
        icon;
    }));
}

-(UILabel *)title{
    return WK_LJZ(_title, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentCenter;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(self.height*0.5+10);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.width);
            make.height.equalTo(@20);
        }];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTSMALL;
        [name setTextColor:[UIColor blackColor]];
        name;

        
    }));

}


@end
