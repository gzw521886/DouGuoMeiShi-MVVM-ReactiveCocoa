//
//  WKMealItemView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/7.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKMealItemView.h"
#import "POP.h"
@interface WKMealItemView ()

@property (nonatomic,weak) UILabel * titleLable;
@property (nonatomic,weak) UILabel * coutLable;
@property (nonatomic,weak) YYAnimatedImageView * leftPic;
@property (nonatomic,weak) YYAnimatedImageView * rightPic;
@property (nonatomic,assign) BOOL isAnimation;
@end

@implementation WKMealItemView
{
 id vv;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _isAnimation=NO;
    }
    return self;
}

- (void)setMealItemSignal:(RACSignal *)mealItemSignal{
    _mealItemSignal=mealItemSignal;
    [mealItemSignal subscribeNext:^(WHomemeals * model) {
        
        [self setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.i]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
        [self.leftPic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[model.is firstObject]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
        [self.rightPic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[model.is lastObject]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
        self.titleLable.text=model.t;
        self.coutLable.text=model.c;
        self.backgroundColor=[UIColor whiteColor];
        
    }];
}

- (void)setAnimationSignal:(RACSignal *)animationSignal{
    _animationSignal=animationSignal;
    
    if (animationSignal) {
        [animationSignal subscribeNext:^(id x) {
            NSString * value=x;
            if ([value isEqualToString:@"begin"]) {
                _isAnimation=YES;
            }
            
            if (_isAnimation) {
                    if ([value isEqualToString:@"right"]) {
                        vv=@(-M_PI/40);
                    }else if([value isEqualToString:@"left"]){
                        vv=@(M_PI/40);
                    }else if([value isEqualToString:@"begin"]){
                        
                    }else if ([value isEqualToString:@"end"]){
                        
                    }else{
                        vv=@(0);
                    }
        
                if (vv==nil) {
                    vv=@(0);
                }
                POPBasicAnimation * basic=[POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
                basic.toValue=vv;
                basic.duration=0.1;
                [self.leftPic.layer pop_addAnimation:basic forKey:@"leftBasicRotation"];
                [self.rightPic.layer pop_addAnimation:basic forKey:@"rightBasicRotation"];
                if ([value isEqualToString:@"end"]) {
                    
                    POPBasicAnimation * basic=[POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
                    basic.fromValue=vv;
                    basic.toValue=@(0);
                    basic.duration=0.5;
                    [self.leftPic.layer pop_addAnimation:basic forKey:@"1leftBasicRotation"];
                    [self.rightPic.layer pop_addAnimation:basic forKey:@"1rightBasicRotation"];
             
                }
                
            }
            
        }];
    }
    
    
}



- (UILabel *)titleLable{
  return  WK_LJZ(_titleLable, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentLeft;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-50);
            make.left.mas_equalTo(50);
            make.width.mas_equalTo(80);
            make.height.equalTo(@30);
        }];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTBIGBIG;
        [name setTextColor:[UIColor blackColor]];
        name;
    }));
}

- (UILabel *)coutLable{
    return  WK_LJZ(_coutLable, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentLeft;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(50+5);
            make.left.mas_equalTo(50);
            make.width.mas_equalTo(80);
            make.height.equalTo(@20);
        }];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTMID;
        [name setTextColor:[UIColor grayColor]];
        name;
    }));
}

- (YYAnimatedImageView *)leftPic{
    return WK_LJZ(_leftPic, ({
        YYAnimatedImageView * icon=[YYAnimatedImageView new];
        [icon.layer setBorderColor:[UIColor colorWithHexString:@"fafafa"].CGColor];
        [icon.layer setBorderWidth:3];
        
        [icon.layer setShadowColor:[UIColor grayColor].CGColor];
        [icon.layer setShadowOffset:CGSizeMake(1, 1)];
        [icon.layer setShadowOpacity:0.5];
        [icon.layer setShadowRadius:2];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-SCREEN_WIDTH/4-10);
            make.width.and.height.mas_equalTo(60);
        }];
        icon;

    }));
}

- (YYAnimatedImageView *)rightPic{
    return WK_LJZ(_rightPic, ({
        YYAnimatedImageView * icon=[YYAnimatedImageView new];
        [icon.layer setBorderColor:[UIColor colorWithHexString:@"fafafa"].CGColor];
        [icon.layer setBorderWidth:3];
        
        [icon.layer setShadowColor:[UIColor grayColor].CGColor];
        [icon.layer setShadowOffset:CGSizeMake(1, 1)];
        [icon.layer setShadowOpacity:0.5];
        [icon.layer setShadowRadius:2];
        
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(SCREEN_WIDTH/4*3);
            make.width.and.height.mas_equalTo(60);
        }];
        icon;
        
    }));

}


@end





