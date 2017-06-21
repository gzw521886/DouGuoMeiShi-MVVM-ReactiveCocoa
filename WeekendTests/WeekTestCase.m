//
//  WeekTestCase.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/23.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import "WeekTestCase.h"

@implementation WeekTestCase

-(NSString *)url{
   // return @"http://api.lanrenzhoumo.com/main/recommend/index/";
    
    //post
    return @"http://api.douguo.net/recipe/home/0/20/0";
}

-(int)refreshCache{
    return NO;
}

-(int)isShowHUD{
    return NO;
}

-(NSString *)statusText{
    return @"";
}

-(NSUInteger *)httpMethod{
    return 2;
}

-(NSDictionary *)params{
  
    //post
    return [NSDictionary dictionaryWithObjectsAndKeys:@"1556484",@"btmid",@"0",@"user_id", nil];
}



-(NSString *)moreUrl{

    return @"http://api.douguo.net/recipe/home/40/20/1567967";  
}




@end
