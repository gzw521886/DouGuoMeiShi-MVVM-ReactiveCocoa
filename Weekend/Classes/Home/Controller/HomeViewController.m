//
//  HomeViewController.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "HomeViewController.h"
#import "WeekHomeProtocolImpl.h"
#import "WKHomeCarouselView.h"
#import "WKHomeViewModel.h"
#import "WKTableViewBindingHelper.h"
@interface HomeViewController ()<UITableViewDelegate>

/**
 *  banner
 */
@property (nonatomic,strong) WKHomeCarouselView * bannerView;
/**
 *  bannerView
 */
@property (nonatomic,strong) UIView * headerView;
/**
 *  table
 */
@property (nonatomic,strong) UITableView * tableView;


@property (nonatomic,strong,readonly) WKHomeViewModel * viewModel;

@property (nonatomic,strong) WKTableViewBindingHelper *tableHelper;

@end

@implementation HomeViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorHex(f4f4f4);
    [self setNavigationBar];
    
}

-(void)bindViewModel{
    [super bindViewModel];
    self.bannerView.imageURLSignal=RACObserve(self.viewModel, bannerData);
    self.bannerView.linkSignal=RACObserve(self.viewModel, linkData);
    self.bannerView.mealSignal=RACObserve(self.viewModel, threeMeals);
    self.tableHelper=[WKTableViewBindingHelper bindingHelperForTableView:self.tableView sourceSignal:RACObserve(self.viewModel, itemData) selectionCommand:nil templateCell:@"ttt" withViewModel:self.viewModel];
    
    //下拉刷新
    @weakify(self);
    self.tableView.mj_header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.requestDataCommand execute:@1];
    }];
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable xx) {
        @strongify(self);
        if (!xx.boolValue) {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
    //上拉刷新
    self.tableView.mj_footer=[MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.requestMoreDataCommand execute:@1];
    }];
    
    [[self.viewModel.requestMoreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable xx) {
        @strongify(self);
        if (!xx.boolValue) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    
    
    
    
    
    
}


- (void)setNavigationBar{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getter
- (UIView *)headerView{
    return WK_LJZ(_headerView, ({
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 370)];
        view.backgroundColor=UIColorHex(f4f4f4);
        [view addSubview:self.bannerView];
        view;
    }));
}

- (WKHomeCarouselView *)bannerView{
    return WK_LJZ(_bannerView, ({
        WKHomeCarouselView * carouse=[[WKHomeCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 370)];
    
        carouse;
    }));

}

-(UITableView *)tableView{
    return WK_LJZ(_tableView, ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.tableHeaderView = self.headerView;
        tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        tableView.backgroundColor=UIColorHex(f4f4f4);
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    }));

}

-(void)viewDidAppear:(BOOL)animated{
    NSIndexSet * set=[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0,self.viewModel.itemData.count)];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

}



@end








