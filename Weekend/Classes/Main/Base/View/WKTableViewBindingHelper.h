//
//  WKTableViewBindingHelper.h
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/6/6.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKViewModel;
@interface WKTableViewBindingHelper : NSObject

@property (weak,nonatomic) id<UITableViewDelegate> delegate;

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                              templateCell:(NSString *)templateCell
                             withViewModel:(WKViewModel *)viewModel;

@end
