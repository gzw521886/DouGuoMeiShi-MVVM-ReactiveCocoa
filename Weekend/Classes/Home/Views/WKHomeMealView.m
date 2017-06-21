//
//  WKHomeMealView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/7.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKHomeMealView.h"
#import "WKMealItemView.h"
#import "UIImageView+ScrollBar.h"
#import "CardsScrollView.h"
@interface WKHomeMealView()
@property (nonatomic ,strong) CardsScrollView * cardsView;
@property (nonatomic,strong) NSMutableArray * mealsModels;
@property (nonatomic,strong) RACSignal * sig;
@end
static NSString  * old;
@implementation WKHomeMealView
{
    CGFloat oldpoint;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
       
    }
    return self;
}

- (void)setMealSignal:(RACSignal *)mealSignal{
    _mealSignal=mealSignal;
    [_mealSignal subscribeNext:^(NSMutableArray * models) {

        if ([models count]>0) {
            [self refreshModels:models];
            if (self.mealsModels.count>0) return;
            [models enumerateObjectsUsingBlock:^(WHomemeals * model, NSUInteger idx, BOOL * _Nonnull stop) {
              
                WKMealItemView *imageView = [[WKMealItemView alloc] init];
                imageView.mealItemSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                    return nil;
                }];
               
                RAC(imageView,animationSignal)=RACObserve(self, sig);
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self.mealsModels addObject:imageView];
              
            }];
            
            dispatch_main_async_safe((^{
                [self cardsView];
            }));
            
            
            RACSignal * offset=[[self.cardsView rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] map:^id(id value) {
                RACTupleUnpack(UIScrollView * view)=value;
                static float newx = 0;
                static float oldIx = 0;
                newx= view.contentOffset.x ;
                NSString * vv;
                if (newx != oldIx ) {
                    if (newx > oldIx) {
                        vv=@"right";
                    }else if(newx < oldIx){
                        vv=@"left";
                    }
                    old=vv;
                    oldIx = newx;
                }else{

                    if (old) {
                        vv= old;
                    }
                }
                return vv;
                
            }];
            
            
            
            RACSignal * scrollBegin=[[self.cardsView rac_signalForSelector:@selector(scrollViewWillBeginDragging:) fromProtocol:@protocol(UIScrollViewDelegate)] map:^id(id value) {
                return @"begin";
            }];
            RACSignal * scrollEnd=[[self.cardsView rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] map:^id(id value) {
                return @"end";
            }];
            
            self.sig=[RACSignal merge:@[scrollBegin,scrollEnd,offset]];
        }

    }];
    
    
    
}


- (void)refreshModels:(NSMutableArray *)models{
    if (self.mealsModels.count>0) {
        for (int i=0;i<self.mealsModels.count;i++) {
            WHomemeals * model=models[i];
            WKMealItemView *imageView=self.mealsModels[i];
            imageView.mealItemSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:model];
                [subscriber sendCompleted];
                return nil;
            }];
        }
        
    }

}




#pragma mark -getter
-(NSMutableArray *)mealsModels{
    return WK_LJZ(_mealsModels, @[].mutableCopy);
}

- (CardsScrollView *)cardsView{
    return WK_LJZ(_cardsView, ({
        CardsScrollView * cardView=[CardsScrollView bannerWithViews:self.mealsModels scrollINterval:0 frame:CGRectMake(0,0, SCREEN_WIDTH, WKMEALBANNERHEIGHT)];
        [self addSubview:cardView];
        [cardView setContentOffset:CGPointMake((self.mealsModels.count-1)*SCREEN_WIDTH, 0) animated:YES];
        cardView;
    }));

}


@end
