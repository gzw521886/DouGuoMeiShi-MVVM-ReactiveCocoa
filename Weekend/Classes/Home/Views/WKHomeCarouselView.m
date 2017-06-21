//
//  WKHomeCarouselView.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/5.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKHomeCarouselView.h"
#import "WeekHomeModel.h"
#import "WKHomebannerView.h"
#import "WKHomeLinkView.h"
#import "WKHomeMealView.h"
#import "CardsScrollView.h"

@interface WKHomeCarouselView()


@property (nonatomic ,strong) CardsScrollView * cardsView;

@property (nonatomic,strong) WKHomeLinkView * linkView;

@property (nonatomic,strong) NSMutableArray * bannerModels;

@property (nonatomic,strong) WKHomeMealView * mealView;
@property (nonatomic,strong) UIImageView * placeholderImageView;
@end

@implementation WKHomeCarouselView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
       
    }
    return self;
}

- (void)setImageURLSignal:(RACSignal *)imageURLSignal{
    _imageURLSignal = imageURLSignal;
    
    [_imageURLSignal subscribeNext:^(id _Nullable x) {
        
        if ([x count] > 0) {
            [self refreshModels:x];
            if(self.bannerModels.count>=5) return;
            [x enumerateObjectsUsingBlock:^(WHomebanner * model, NSUInteger idx, BOOL * _Nonnull stop) {

                WKHomebannerView *imageView = [[WKHomebannerView alloc] init];
                imageView.bannerModel=model;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self.bannerModels addObject:imageView];
            }];
            
            dispatch_main_async_safe(^{
                [self cardsView];
                
            });
        }
        
       
    }];
}

- (void)refreshModels:(NSMutableArray *)models{
    if (self.bannerModels.count>=5) {
        for (int i=0; i<self.bannerModels.count; i++) {
            WHomebanner * model=models[i];
            WKHomebannerView *imageView=self.bannerModels[i];
            imageView.bannerModel=model;
        }
    }

}


- (void)setLinkSignal:(RACSignal *)linkSignal{
    _linkSignal=linkSignal;
    self.linkView.linkSignal=linkSignal;
}

- (void)setMealSignal:(RACSignal *)mealSignal{
    _mealSignal=mealSignal;
    self.mealView.mealSignal=mealSignal;
}



#pragma mark - getter


- (NSMutableArray *)bannerModels{
    return WK_LJZ(_bannerModels, @[].mutableCopy);

}



-(CardsScrollView *)cardsView{
    return WK_LJZ(_cardsView, ({
        CardsScrollView * cardView=[CardsScrollView bannerWithViews:self.bannerModels scrollINterval:8 frame:CGRectMake(0, 0, SCREEN_WIDTH, WKBANNERHEIGHT)];
        [self addSubview:cardView];
        cardView;
    }));

}

-(WKHomeLinkView *)linkView{
    return WK_LJZ(_linkView, ({
        WKHomeLinkView * linkView=[[WKHomeLinkView alloc] initWithFrame:CGRectMake(0, WKBANNERHEIGHT, SCREEN_WIDTH, WKLINKHEIGHT)];
        [self addSubview:linkView];
        linkView;
    }));
}

- (WKHomeMealView *)mealView{
    return WK_LJZ(_mealView, ({
        WKHomeMealView * mealV=[[WKHomeMealView alloc] initWithFrame:CGRectMake(0, WKBANNERHEIGHT+WKLINKHEIGHT+10, SCREEN_WIDTH, WKMEALBANNERHEIGHT)];
        [self addSubview:mealV];
        mealV;
    }));

}

@end

