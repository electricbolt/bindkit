/*******************************************************************************
 * EBKUIBarButtonItemTests.h                                                   *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"

@interface BarButtonItemModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;

@end

@implementation BarButtonItemModel

@end

@interface EBKUIBarButtonItemTests : XCTestCase {
    UIBarButtonItem* view;
    BarButtonItemModel* model;
}

@end

@implementation EBKUIBarButtonItemTests

- (void) setUp {
    [super setUp];
    model = [BarButtonItemModel new];
    view = [UIBarButtonItem new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabled {
    [model bindKey: @"enabled" view: view viewKey: UIBarButtonItemEnabled];
    model.enabled = NO;
    XCTAssertFalse(view.enabled);
    model.enabled = YES;
    XCTAssertTrue(view.enabled);
    model.enabled = NO;
    XCTAssertFalse(view.enabled);
    
    view.enabled = YES;
    XCTAssertTrue(model.enabled);
    view.enabled = NO;
    XCTAssertFalse(model.enabled);
    view.enabled = YES;
    XCTAssertTrue(model.enabled);
}

@end

