//
//  WKTableViewBindingHelper.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/6.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WKTableViewBindingHelper.h"
#import "WKViewModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import "WKReactiveView.h"

@interface WKTableViewBindingHelper()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSArray * data;

@property (nonatomic,strong)RACCommand * didSelectionCommand;

@property (copy,nonatomic) NSString * cellIdentifier;

@property (strong,nonatomic) WKViewModel * viewModel;

@end

@implementation WKTableViewBindingHelper

- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand withCellType:(NSDictionary *)CellTypeDic withViewModel:(WKViewModel *)viewModel{

    if (self=[super init]) {
        _tableView=tableView;
        _data=[NSArray array];
        _didSelectionCommand=didSelectionCommand;
        _viewModel=viewModel;
        
        @weakify(self);
        [source subscribeNext:^(id x) {
            @strongify(self);
            self.data=x;
            [self.tableView reloadData];
        }];
        
        _tableView.dataSource=self;
        _tableView.delegate=self;

        Class cell =  NSClassFromString(@"UITableViewCell");
        Class tacell=  NSClassFromString(@"WKHomeTaCell");
        Class mcell=  NSClassFromString(@"WHomeMCell");
        Class advcell=  NSClassFromString(@"WHomeADVCell");
        Class rcell=  NSClassFromString(@"WHomeRCell");
        [_tableView registerClass:cell forCellReuseIdentifier:@"aaaa"];
        [_tableView registerClass:tacell forCellReuseIdentifier:@"8"];
        [_tableView registerClass:mcell forCellReuseIdentifier:@"3"];
        [_tableView registerClass:advcell forCellReuseIdentifier:@"100"];
        [_tableView registerClass:rcell forCellReuseIdentifier:@"2"];
        
        _tableView.estimatedRowHeight =300;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }

    return self;
}

+(instancetype)bindingHelperForTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCell:(NSString *)templateCell withViewModel:(WKViewModel *)viewModel{
    
    NSDictionary * cellDic=@{@"cellType":@"cell1",@"cellName":templateCell};
   
    return [[WKTableViewBindingHelper alloc] initWithTableView:tableView sourceSignal:source selectionCommand:didSelectionCommand withCellType:cellDic withViewModel:viewModel];

}
-(void)dealloc{
    self.delegate=self;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WHomeCellModel * model=self.data[indexPath.row];
    id<WKReactiveView> cell=[tableView dequeueReusableCellWithIdentifier:model.type];
  
    [cell bindViewModel:model];
    return (UITableViewCell *)cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   WHomeCellModel * model=self.data[indexPath.row];
    CGFloat cellH;
        switch ([model.type integerValue]) {
            case 8:
                cellH=330;
                break;
            case 3:
                cellH=250;
                break;
            case 100:
              cellH=330;
                break;
            case 2:
                cellH=350;
                break;
            default:
                cellH=350;
                break;
    }
    return cellH;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}






@end
















