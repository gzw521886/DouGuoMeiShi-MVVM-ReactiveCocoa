//
//  WHomeMCell.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/8.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WHomeMCell.h"

@interface WHomeMCell ()

/**
 *  cell头部图片
 */
@property (nonatomic,strong) YYAnimatedImageView * topView;
/**
 *  cell头部图片菜品数量
 */
@property (nonatomic,strong) UILabel * topCount;
/**
 *  cell头部图片菜品标题
 */
@property (nonatomic,strong) UILabel * topTitle;
/**
 *  cell头部图片菜品作者
 */
@property (nonatomic,strong) UILabel * topAuthor;

@property (nonatomic,strong) UIView * keepView;
@end

@implementation WHomeMCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(WKCELL_TOPVIEWHEIGHT);
        make.bottom.equalTo(self);
    }];
    
    [self.keepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.and.right.equalTo(self.topView);
        make.height.mas_equalTo(30);
    }];
    
    [self.topCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topTitle.mas_top).offset(-5);
        make.left.and.right.equalTo(self.topView);
        make.height.mas_equalTo(20);
    }];
    [self.topAuthor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitle.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.topView);
        make.height.mas_equalTo(20);
    }];
    
    
    
}

#pragma  mark - Bind
-(void)bindViewModel:(id)viewModel{
    
    WHomeCellModel * model=viewModel;
    WHomeMCellModel * cellModel=model.m;
    WHomebannerUser * userModel=cellModel.a;
     [self.topView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",cellModel.b]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation];
    
    self.topCount.text=[NSString stringWithFormat:@"◆  共%@道菜  ◆",cellModel.c];
    self.topTitle.text=cellModel.t;
    self.topAuthor.text=[NSString stringWithFormat:@"由%@创建",userModel.n];
    
}


#pragma mark - getter
- (YYAnimatedImageView *)topView{
    return WK_LJZ(_topView, ({
        YYAnimatedImageView * backView=[YYAnimatedImageView new];
        [self addSubview:backView];
        [backView addSubview:self.keepView];
        backView;
    }));
}

- (UIView *)keepView{
    return WK_LJZ(_keepView, ({
        UIView * back=[[UIView alloc] init];
        back.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.5];
        back;
    
    }));

}

- (UILabel *)topCount{
    return WK_LJZ(_topCount, ({
        UILabel * name=[[UILabel alloc] init];
        name.textAlignment=NSTextAlignmentCenter;
        [self.topView addSubview:name];
        name.backgroundColor=[UIColor clearColor];
        name.font=WKFONTBOLDMID;
        [name setTextColor:[UIColor whiteColor]];
        name;
    }));
    
}

- (UILabel *)topTitle{
    return  WK_LJZ(_topTitle, ({
        UILabel * title=[[UILabel alloc] init];
        title.textAlignment=NSTextAlignmentCenter;
        [self.topView addSubview:title];
        title.backgroundColor=[UIColor clearColor];
        title.font=WKFONTBOLDBIGBIG;
        [title setTextColor:[UIColor whiteColor]];
        title;
    }));
}

- (UILabel *)topAuthor{
    return  WK_LJZ(_topAuthor, ({
        UILabel * author=[[UILabel alloc] init];
        author.textAlignment=NSTextAlignmentCenter;
        [self.topView addSubview:author];
        author.backgroundColor=[UIColor clearColor];
        author.font=WKFONTBIG;
        [author setTextColor:[UIColor whiteColor]];
        author;
    }));
    
}





@end
