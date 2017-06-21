//
//  WKHomeLinkView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/7.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKHomeLinkView.h"
#import "WKLinkItemView.h"
#import "POP.h"

@interface WKHomeLinkView()
@property (nonatomic,strong)NSMutableArray * items;
@end

@implementation WKHomeLinkView

-(void)setLinkSignal:(RACSignal *)linkSignal{
    
    self.backgroundColor=[UIColor whiteColor];
    [linkSignal subscribeNext:^(NSArray * x) {
        CGFloat iw=SCREEN_WIDTH/4;
        CGFloat ih=WKLINKHEIGHT;
        CGFloat iy=0;
        CGFloat ix=0;
        if ([x count]>0) {
            if(self.items.count>=4) return;
            for (int i=0; i<x.count; i++) {
                ix=i*iw;
                WKLinkItemView * item=[[WKLinkItemView alloc] initWithFrame:CGRectMake(ix, iy, iw, ih)];
                item.itemSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:x[i]];
                    [subscriber sendCompleted];
                    return nil;
                }];
                [self.items addObject:item];
                [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    return nil;
                }] delay:i*0.1+0.5] subscribeNext:^(id x) {
                    [self addSubview:item];
                    
                    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
                    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
                    sprintAnimation.springBounciness = 20.f;
                    [item pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
                    
                    
                }];
                
            }
        }
    }];
    
}

- (void)refreshItem{
    if (self.items.count>=4) {
//        [self.items enumerateObjectsUsingBlock:^(WKLinkItemView * item, NSUInteger idx, BOOL * _Nonnull stop) {
//            [item removeFromSuperview];
//        }];
//        [self.items removeAllObjects];
        return;
    }

}

-(NSMutableArray *)items{
    return WK_LJZ(_items, ({
        NSMutableArray * array=[NSMutableArray arrayWithCapacity:4];
       
        array;
    }));
}



@end
