// EBKUILabelTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@interface LabelModel : NSObject {
}

@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, strong) NSString* string;
@property(nonatomic, assign) NSAttributedString* attributedString;

@end

@implementation LabelModel

@end

@interface EBKUILabelTests : XCTestCase {
    UILabel* view;
    LabelModel* model;
}

@end

@implementation EBKUILabelTests

- (void) setUp {
    [super setUp];
    model = [LabelModel new];
    view = [UILabel new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testHidden {
    model.hidden = NO;

    [model bindKey: @"hidden" view: view viewKey: UIDatePickerHidden];

    model.hidden = NO;
    XCTAssertFalse(view.hidden);
    model.hidden = YES;
    XCTAssertTrue(view.hidden);
    model.hidden = NO;
    XCTAssertFalse(view.hidden);

    view.hidden = YES;
    XCTAssertTrue(model.hidden);
    view.hidden = NO;
    XCTAssertFalse(model.hidden);
    view.hidden = YES;
    XCTAssertTrue(model.hidden);
}

- (void) testString {
    NSString* a = @"a";
    NSString* b = @"b";

    [model bindKey: @"string" view: view viewKey: UILabelText];

    model.string = a;
    XCTAssertEqualObjects(view.text, a);
    model.string = b;
    XCTAssertEqualObjects(view.text, b);
    model.string = a;
    XCTAssertEqualObjects(view.text, a);

    view.text = b;
    XCTAssertEqualObjects(model.string, b);
    view.text = a;
    XCTAssertEqualObjects(model.string, a);
    view.text = b;
    XCTAssertEqualObjects(model.string, b);
}

- (void) testAttributedString {
    NSAttributedString* a = [[NSAttributedString alloc] initWithString: @"a"];
    NSAttributedString* b = [[NSAttributedString alloc] initWithString: @"b"];

    [model bindKey: @"attributedString" view: view viewKey: UILabelAttributedText];

    model.attributedString = a;
    XCTAssertEqualObjects(view.attributedText, a);
    model.attributedString = b;
    XCTAssertEqualObjects(view.attributedText, b);
    model.attributedString = a;
    XCTAssertEqualObjects(view.attributedText, a);

    view.attributedText = b;
    XCTAssertEqualObjects(model.attributedString, b);
    view.attributedText = a;
    XCTAssertEqualObjects(model.attributedString, a);
    view.attributedText = b;
    XCTAssertEqualObjects(model.attributedString, b);
}

@end
