//
//  WHomeADVCell.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/8.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WHomeADVCell.h"

@interface WHomeADVCell ()

/**
 *  cell头部图片
 */
@property (nonatomic,strong) YYAnimatedImageView * topView;

/**
 * 头部图片下方标题
 */
@property (nonatomic,strong) UILabel * title;
/**
 *  描述
 */
@property (nonatomic,strong) UILabel * content;

@property (nonatomic,strong) UILabel * adv;
@end

@implementation WHomeADVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(WKCELL_TOPVIEWHEIGHT);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(self.mas_top).offset(WKCELL_TOPVIEWHEIGHT+10);
        make.left.and.right.equalTo(self);
       
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.mas_left).offset(CELL_MARGIN);
        make.right.equalTo(self.mas_right).offset(-CELL_MARGIN);
        make.bottom.equalTo(self);
    }];
    
    [self.adv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-10);
    }];
    
}

#pragma  mark - Bind
-(void)bindViewModel:(id)viewModel{
    
    WHomeCellModel * model=viewModel;
    WHomeADVCellModel * advModel=model.dsp;
    if(advModel.t==nil)advModel.t=@"这就是一个广告";
    if(advModel.d==nil)advModel.d=@"特单纯的一条广告";
    [self.topView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",advModel.i]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
   
   
    self.title.text=advModel.t;
    self.content.text=advModel.d;
    self.adv.text=@"广告";
}


#pragma mark - getter
- (YYAnimatedImageView *)topView{
    return WK_LJZ(_topView, ({
        YYAnimatedImageView * backView=[YYAnimatedImageView new];
        [self addSubview:backView];
        backView;
    }));
}


- (UILabel *)title{
    return WK_LJZ(_title, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentCenter;
        [self addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTBOLDBIGBIG;
        [name setTextColor:[UIColor grayColor]];
        name;
    }));
}

- (UILabel *)content{
    
    return WK_LJZ(_content, ({
        UILabel * content=[[UILabel alloc] init];
        content.textAlignment=NSTextAlignmentLeft;
        [self addSubview:content];
        content.backgroundColor=[UIColor clearColor];
        content.font=WKFONTSMALL;
        [content setTextColor:[UIColor grayColor]];
        content;
    }));
}

-(UILabel *)adv{
    return WK_LJZ(_adv, ({
        UILabel * content=[[UILabel alloc] init];
        content.textAlignment=NSTextAlignmentCenter;
        [self.topView addSubview:content];
        content.backgroundColor=[UIColor clearColor];
        content.font=WKFONTBOLDMID;
        [content setTextColor:[UIColor whiteColor]];
        content.layer.borderColor=[UIColor whiteColor].CGColor;
        content.layer.borderWidth=2;
        content.layer.masksToBounds=YES;
        content.layer.cornerRadius=5;
    
        content;
    }));

}

@end
