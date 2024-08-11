// EBKMulticastDelegateTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@protocol ArbitaryDelegate

- (void) arbitaryMethod;

@end

@interface ArbitaryObject: NSObject<ArbitaryDelegate> {
@public
    XCTestExpectation* expectation;
}

@end

@implementation ArbitaryObject

- (void) arbitaryMethod {
    [expectation fulfill];
}

@end

@interface EBKMulticastDelegateTests : XCTestCase {
    EBKMulticastDelegate* multicast;
    id<ArbitaryDelegate> delegate;
    ArbitaryObject* obj1;
    ArbitaryObject* obj2;
}

@end

@implementation EBKMulticastDelegateTests

- (void) setUp {
    [super setUp];
    multicast = [EBKMulticastDelegate new];
    obj1 = [ArbitaryObject new];
    obj2 = [ArbitaryObject new];
    delegate = (id<ArbitaryDelegate>) multicast;
}

- (void) tearDown {
    [super tearDown];
}

- (void) testPrimaryOnly {
    obj1->expectation = [self expectationWithDescription: @"obj1"];
    multicast.primaryDelegate = obj1;
    [delegate arbitaryMethod];
    [self waitForExpectationsWithTimeout: 0.1 handler: nil];
}

- (void) testSecondaryOnly {
    obj2->expectation = [self expectationWithDescription: @"obj2"];
    multicast.secondaryDelegate = obj2;
    [delegate arbitaryMethod];
    [self waitForExpectationsWithTimeout: 0.1 handler: nil];
}

- (void) testPrimaryAndSecondaryOnly {
    obj1->expectation = [self expectationWithDescription: @"obj1"];
    obj2->expectation = [self expectationWithDescription: @"obj2"];
    multicast.primaryDelegate = obj1;
    multicast.secondaryDelegate = obj2;
    [delegate arbitaryMethod];
    [self waitForExpectationsWithTimeout: 0.1 handler: nil];
}
@end

