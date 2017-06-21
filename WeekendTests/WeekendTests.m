//
//  WeekendTests.m
//  WeekendTests
//
//  Created by JiubaiMacMZG on 2017/5/16.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WKNetWorking.h"
@interface WeekendTests : XCTestCase

@end

@implementation WeekendTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString * str=[WKNetWorking encodeUrl:@"http://api.lanrenzhoumo.com/main/recommend/index"];
    XCTAssertTrue(str.length>0);
    
    
}




- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
