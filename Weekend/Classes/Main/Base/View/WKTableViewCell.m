//
//  WKTableViewCell.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/8.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKTableViewCell.h"
//#import "UITableView+FDTemplateLayoutCell.h"
@implementation WKTableViewCell


-(void)setFrame:(CGRect)frame{
    frame.size.height-=10;
    [super setFrame:frame];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundView.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.backgroundColor=[UIColor clearColor];
   // self.fd_enforceFrameLayout=YES;
    return self;
}
@end
