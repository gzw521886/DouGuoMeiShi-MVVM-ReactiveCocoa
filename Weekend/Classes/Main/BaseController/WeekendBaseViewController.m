//
//  WeekendBaseViewController.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WeekendBaseViewController.h"
#import "WKHomeViewModel.h"
@interface WeekendBaseViewController ()
@property (strong ,nonatomic,readwrite) WKViewModel * viewModel;
@end

@implementation WeekendBaseViewController

- (instancetype)initWithViewModel:(WKViewModel *)viewModel{
    self = [super init];
    if (self) {
        self.viewModel=viewModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
   
}

- (void)bindViewModel{

    [self.viewModel.requestDataCommand execute:@1];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
