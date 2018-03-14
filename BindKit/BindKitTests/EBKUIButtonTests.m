/*******************************************************************************
 * EBKUIButtonTests.h                                                          *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"

@interface ButtonModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) BOOL hidden;

@end

@implementation ButtonModel

@end

@interface EBKUIButtonTests : XCTestCase {
    UIButton* view;
    ButtonModel* model;
}

@end

@implementation EBKUIButtonTests

- (void) setUp {
    [super setUp];
    model = [ButtonModel new];
    view = [UIButton new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabledHidden {
    [model bindKey: @"enabled" view: view viewKey: UIButtonEnabled];
    [model bindKey: @"hidden" view: view viewKey: UIButtonHidden];

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

@end


