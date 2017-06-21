//
//  WHomeRCell.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/8.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WHomeRCell.h"


@interface WHomeRCell ()

/**
 *  cell头部图片
 */
@property (nonatomic,strong) YYAnimatedImageView * topView;

/**
 * 头部图片下方标题
 */
@property (nonatomic,strong) UILabel * title;
/**
 *  作者头像
 */
@property (nonatomic,strong) YYAnimatedImageView * userIcon;
/**
 *  作者昵称
 */
@property (nonatomic,strong) UILabel * userName;
/**
 *  描述
 */
@property (nonatomic,strong) UILabel * content;

@end


@implementation WHomeRCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(WKCELL_TOPVIEWHEIGHT);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(30);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self).offset(SCREEN_WIDTH*0.5-60);
        make.width.and.height.mas_equalTo(25);
    }];

    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.left.equalTo(self.userIcon.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH*0.5);
        make.height.mas_equalTo(20);
        
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(CELL_MARGIN);
        make.left.equalTo(self.mas_left).offset(CELL_MARGIN);
        make.right.equalTo(self.mas_right).offset(-CELL_MARGIN);
        make.bottom.equalTo(self);
    }];
    
    
    
    
}

#pragma  mark - Bind
-(void)bindViewModel:(id)viewModel{
    
    WHomeCellModel * model=viewModel;
    WHomeRCellModel * rmodel=model.r;
    WHomebannerUser * userModel=rmodel.a;
     [self.topView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",rmodel.p]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
    self.title.text=rmodel.n;
    [self.userIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userModel.p]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
    self.userName.text=userModel.n;
    self.content.text=rmodel.cookstory;
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
        name.text=@"lalalala";
        name.textAlignment=NSTextAlignmentCenter;
        [self addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTBOLDBIGBIG;
        [name setTextColor:[UIColor grayColor]];
        name;
    }));
}


- (YYAnimatedImageView *)userIcon{
    return WK_LJZ(_userIcon, ({
        YYAnimatedImageView * icon=[YYAnimatedImageView new];
        icon.layer.masksToBounds=YES;
        icon.layer.cornerRadius=25*0.5;
        [self addSubview:icon];
        icon;
    }));
}

- (UILabel *)userName{
    return WK_LJZ(_userName, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentLeft;
        [self addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTBIG;
        [name setTextColor:[UIColor grayColor]];
        name;
    }));
}

- (UILabel *)content{
    
    return WK_LJZ(_content, ({
        UILabel * content=[[UILabel alloc] init];
        content.textAlignment=NSTextAlignmentLeft;
        content.numberOfLines=0;
        [self addSubview:content];
        content.backgroundColor=[UIColor clearColor];
        content.font=WKFONTSMALL;
        [content setTextColor:[UIColor grayColor]];
        content;
    }));
}




@end
