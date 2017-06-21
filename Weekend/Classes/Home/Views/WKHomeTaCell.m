//
//  WKHomeTaCell.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/8.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKHomeTaCell.h"

@interface WKHomeTaCell ()
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

@end



@implementation WKHomeTaCell


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(WKCELL_TOPVIEWHEIGHT);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(CELL_MARGIN);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(CELL_TITLEHEIGHT);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.mas_left).offset(CELL_MARGIN);
        make.right.equalTo(self.mas_right).offset(-CELL_MARGIN);
        make.height.mas_equalTo(CELL_COUNTHEIGHT);
       
    }];
    
}


#pragma  mark - Bind
-(void)bindViewModel:(id)viewModel{
    
    WHomeCellModel * model=viewModel;
    WHomeTaCellModel * TaCellModel=model.ta;
    
    [self.topView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",TaCellModel.i]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
    self.title.text=TaCellModel.t;
    self.content.text=TaCellModel.c;
    
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
        content.numberOfLines=0;
        [content setTextColor:[UIColor grayColor]];
        content;
    }));
}
@end
