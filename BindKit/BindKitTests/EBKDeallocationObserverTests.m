/*******************************************************************************
 * EBKDeallocationObserverTests.h                                              *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "EBKDeallocationObserver.h"

@interface TestObj: NSObject
@end

@implementation TestObj
@end

@interface EBKDeallocationObserverTests : XCTestCase

@end

@implementation EBKDeallocationObserverTests

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testDealloc {
    XCTestExpectation* expectation = [self expectationWithDescription: @"deallocation"];
    TestObj* obj = [TestObj new];
    [EBKDeallocationObserver associate: obj block: ^{
        [expectation fulfill];
    }];
    obj = nil;
    [self waitForExpectationsWithTimeout: 0.1 handler: nil];
}

@end
