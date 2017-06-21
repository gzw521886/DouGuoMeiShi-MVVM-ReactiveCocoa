//
//  UIImageView+ScrollBar.m
//  lunbo
//
//  Created by JiubaiMacMZG on 2017/6/15.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "UIImageView+ScrollBar.h"

@implementation UIImageView (ScrollBar)

- (void)setAlpha:(CGFloat)alpha
{
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    for (UIView * view in sc.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]&&view.frame.size.height<3) {
                            view.backgroundColor=[UIColor redColor];
                           
                        }
                    }
                    return;
                }
            }  
        }  
    }  
    
    [super setAlpha:alpha];
}



@end
