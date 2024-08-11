// NSObjectEBKBindingTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@interface NSObjModel : NSObject {
}

@property(nonatomic, assign) BOOL boolean;
@property(nonatomic, assign) NSInteger modelCount;

@end

@implementation NSObjModel

- (void) boundPropertiesDidUpdate {
    _modelCount++;
}

@end

@interface NSObjectEBKBindingTests : XCTestCase<EBKBoundPropertiesDelegate> {
    NSObjModel* model;
    UISwitch* view;
    NSInteger delegateCount;
}

@end

@implementation NSObjectEBKBindingTests

- (void) setUp {
    [super setUp];
    model = [NSObjModel new];
    view = [UISwitch new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testLibraryVersion {
    XCTAssertEqualObjects(EBKVersion(), @"1.1.0");
}

- (void) testBindingKey {
    [model bindKey: @"boolean" view: view viewKey: @"enabled"];
    model.boolean = NO;
    XCTAssertFalse(view.enabled);
    model.boolean = YES;
    XCTAssertTrue(view.enabled);
    model.boolean = NO;
    XCTAssertFalse(view.enabled);
    view.enabled = YES;
    XCTAssertTrue(model.boolean);
    view.enabled = NO;
    XCTAssertFalse(model.boolean);
    view.enabled = YES;
    XCTAssertTrue(model.boolean);
}

- (void) testBindingSel {
    [model bindSel: @selector(boolean) view: view viewKey: @"enabled"];
    model.boolean = NO;
    XCTAssertFalse(view.enabled);
    model.boolean = YES;
    XCTAssertTrue(view.enabled);
    model.boolean = NO;
    XCTAssertFalse(view.enabled);
    view.enabled = YES;
    XCTAssertTrue(model.boolean);
    view.enabled = NO;
    XCTAssertFalse(model.boolean);
    view.enabled = YES;
    XCTAssertTrue(model.boolean);
}

- (void) boundPropertiesDidUpdate {
    delegateCount++;
}

- (void) testDelegatesBlock {
    __block NSInteger updateCount = 0;

    model.boundPropertiesUpdateBlock = ^{
        updateCount++;
    };

    model.boundPropertiesDelegate = self;

    [model bindKey: @"boolean" view: view viewKey: @"enabled"];
    model.boolean = NO;

    XCTAssertEqual(2, updateCount);         // called on boundPropertiesUpdateBlock assignment and 'model.boolean = NO'
    XCTAssertEqual(2, delegateCount);       // called on delegate assignment and 'model.boolean = NO'
    XCTAssertEqual(1, model.modelCount);    // called on 'model.boolean = NO'
}

@end
