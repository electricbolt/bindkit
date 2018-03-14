/*******************************************************************************
 * EBKUIStepperTests.h                                                         *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"

@interface StepperModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) double value;

@end

@implementation StepperModel

@end

@interface EBKUIStepperTests : XCTestCase {
    UIStepper* view;
    StepperModel* model;
}

@end

@implementation EBKUIStepperTests

- (void) setUp {
    [super setUp];
    model = [StepperModel new];
    view = [UIStepper new];
    view.minimumValue = 0.0;
    view.maximumValue = 10.0;
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabledHidden {
    [model bindKey: @"enabled" view: view viewKey: UIStepperEnabled];
    [model bindKey: @"hidden" view: view viewKey: UIStepperHidden];

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

- (void) testValue {
    [model bindKey: @"value" view: view viewKey: UIStepperValue];

    model.value = 2.0;
    XCTAssertEqual(view.value, 2.0);
    model.value = 3.0;
    XCTAssertEqual(view.value, 3.0);
    model.value = 1.0;
    XCTAssertEqual(view.value, 1.0);

    view.value = 2.0;
    XCTAssertEqual(model.value, 2.0);
    view.value = 3.0;
    XCTAssertEqual(model.value, 3.0);
    view.value = 1.0;
    XCTAssertEqual(model.value, 1.0);
}

@end


