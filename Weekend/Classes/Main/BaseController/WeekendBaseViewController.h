//
//  WeekendBaseViewController.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKViewModel;
@interface WeekendBaseViewController : UIViewController

@property (strong ,nonatomic ,readonly) WKViewModel * viewModel;


- (instancetype) initWithViewModel:(WKViewModel *)viewModel;

- (void)bindViewModel;

@end
