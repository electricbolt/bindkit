/*******************************************************************************
 * EBKUIDatePickerTests.h                                                      *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"

@interface DateModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, strong) NSDate* date;

@end

@implementation DateModel

@end

@interface EBKUIDatePickerTests : XCTestCase {
    UIDatePicker* view;
    DateModel* model;
}

@end

@implementation EBKUIDatePickerTests

- (void) setUp {
    [super setUp];
    model = [DateModel new];
    view = [UIDatePicker new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabledHidden {
    model.enabled = NO;
    model.hidden = NO;

    [model bindKey: @"enabled" view: view viewKey: UIDatePickerEnabled];
    [model bindKey: @"hidden" view: view viewKey: UIDatePickerHidden];

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

- (void) testDate {
    NSDate* now = [NSDate date];
    NSDate* future = [[NSDate date] dateByAddingTimeInterval: 60*60*24];

    model.date = now;

    [model bindKey: @"date" view: view viewKey: UIDatePickerDate];

    model.date = now;
    XCTAssertEqualObjects(view.date, now);
    model.date = future;
    XCTAssertEqualObjects(view.date, future);
    model.date = now;
    XCTAssertEqualObjects(view.date, now);

    view.date = future;
    XCTAssertEqualObjects(model.date, future);
    view.date = now;
    XCTAssertEqualObjects(model.date, now);
    view.date = future;
    XCTAssertEqualObjects(model.date, future);

    [view setDate: future animated: YES];
    XCTAssertEqualObjects(model.date, future);
    [view setDate: now animated: YES];
    XCTAssertEqualObjects(model.date, now);
    [view setDate: future animated: YES];
    XCTAssertEqualObjects(model.date, future);
}
@end
