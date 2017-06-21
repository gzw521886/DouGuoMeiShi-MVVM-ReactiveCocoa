//
//  WKNetWorkingTest.m
//  Weekend
//
//  Created by JiubaiMacMZG on 2017/5/23.
//  Copyright © 2017年 JiubaiMacmini. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeekTestCase.h"
#import "WKNetWorking.h"
#import "WeekHomeModel.h"


@interface WKNetWorkingTest : WeekTestCase

@end

@implementation WKNetWorkingTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



//首页数据请求
- (void)testPostRequestWithUrl{
    __block id responseObject = nil;
    __block id responseError = nil;
    
    XCTestExpectation * expectation=[self expectationWithDescription:@"post yuqi"];
    NSURLSessionTask * task;
    task=[WKNetWorking postWithUrl:self.url refreshCache:self.refreshCache params:self.params success:^(id response) {
        NSLog(@"post==>%@",response);
        responseObject=response;

        
        [expectation fulfill];
    } fail:^(NSError *error) {
        responseError=error;
        [expectation fulfill];
    }];
    [task resume];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertNotNil(responseObject);
    XCTAssertNil(responseError);
}


//首页请求更多数据
- (void)testPostRequestMoreWithUrl{
    __block id responseObject = nil;
    __block id responseError = nil;
    
    XCTestExpectation * expectation=[self expectationWithDescription:@"post more"];
    NSURLSessionTask * task;
    task=[WKNetWorking postWithUrl:self.moreUrl refreshCache:self.refreshCache params:self.params success:^(id response) {
        NSLog(@"postMore==>%@",response);
        responseObject=response;
        
        [expectation fulfill];
    } fail:^(NSError *error) {
        responseError=error;
        [expectation fulfill];
    }];
    [task resume];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    XCTAssertNotNil(responseObject);
    XCTAssertNil(responseError);


}


- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
