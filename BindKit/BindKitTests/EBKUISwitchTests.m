// EBKUISwitchTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@interface SwitchModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL on;

@end

@implementation SwitchModel

@end

@interface EBKUISwitchTests : XCTestCase {
    UISwitch* view;
    SwitchModel* model;
}

@end

@implementation EBKUISwitchTests

- (void) setUp {
    [super setUp];
    model = [SwitchModel new];
    view = [UISwitch new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabledHidden {
    [model bindKey: @"enabled" view: view viewKey: UISwitchEnabled];
    [model bindKey: @"hidden" view: view viewKey: UISwitchHidden];

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

- (void) testOn {
    [model bindKey: @"on" view: view viewKey: UISwitchOn];

    model.on = YES;
    XCTAssertTrue(view.on);
    model.on = NO;
    XCTAssertFalse(view.on);
    model.on = YES;
    XCTAssertTrue(view.on);

    view.on = YES;
    XCTAssertTrue(model.on);
    view.on = NO;
    XCTAssertFalse(model.on);
    view.on = YES;
    XCTAssertTrue(model.on);
}

@end



