// EBKUISegmentedControlTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@interface SegmentedModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) NSInteger segment;

@end

@implementation SegmentedModel

@end

@interface EBKUISegmentedControlTests : XCTestCase {
    UISegmentedControl* view;
    SegmentedModel* model;
}

@end

@implementation EBKUISegmentedControlTests

- (void) setUp {
    [super setUp];
    model = [SegmentedModel new];
    view = [[UISegmentedControl alloc] initWithItems: @[@"One",@"Two",@"Three",@"Four"]];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabledHidden {
    [model bindKey: @"enabled" view: view viewKey: UISegmentedControlEnabled];
    [model bindKey: @"hidden" view: view viewKey: UISegmentedControlHidden];

    model.enabled = NO;
    model.hidden = NO;
    XCTAssertFalse(view.enabled);
    XCTAssertFalse(view.hidden);
    model.enabled = YES;
    XCTAssertTrue(view.enabled);
    XCTAssertFalse(view.hidden);
    model.enabled = NO;
    XCTAssertFalse(view.enabled);
    XCTAssertFalse(view.hidden);

    view.enabled = YES;
    XCTAssertTrue(model.enabled);
    XCTAssertFalse(model.hidden);
    view.enabled = NO;
    XCTAssertFalse(model.enabled);
    XCTAssertFalse(model.hidden);
    view.enabled = YES;
    XCTAssertTrue(model.enabled);
    XCTAssertFalse(model.hidden);

    model.enabled = NO;
    model.hidden = NO;
    XCTAssertFalse(view.enabled);
    XCTAssertFalse(view.hidden);
    model.hidden = YES;
    XCTAssertFalse(view.enabled);
    XCTAssertTrue(view.hidden);
    model.hidden = NO;
    XCTAssertFalse(view.enabled);
    XCTAssertFalse(view.hidden);

    view.hidden = YES;
    XCTAssertFalse(model.enabled);
    XCTAssertTrue(model.hidden);
    view.hidden = NO;
    XCTAssertFalse(model.enabled);
    XCTAssertFalse(model.hidden);
    view.hidden = YES;
    XCTAssertFalse(model.enabled);
    XCTAssertTrue(model.hidden);
}

- (void) testSegmentedControlIndex {
    [model bindKey: @"segment" view: view viewKey: UISegmentedControlSelectedSegmentIndex];

    model.segment = 2;
    XCTAssertEqual(view.selectedSegmentIndex, 2);
    model.segment = 3;
    XCTAssertEqual(view.selectedSegmentIndex, 3);
    model.segment = 1;
    XCTAssertEqual(view.selectedSegmentIndex, 1);

    view.selectedSegmentIndex = 2;
    XCTAssertEqual(model.segment, 2);
    view.selectedSegmentIndex = 3;
    XCTAssertEqual(model.segment, 3);
    view.selectedSegmentIndex = 1;
    XCTAssertEqual(model.segment, 1);
}

@end
