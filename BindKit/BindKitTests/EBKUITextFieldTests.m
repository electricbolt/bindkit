/*******************************************************************************
 * EBKUITextFieldTests.h                                                       *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"

@interface TextFieldModel : NSObject {
}

@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, strong) NSString* string;
@property(nonatomic, assign) NSAttributedString* attributedString;

@end

@implementation TextFieldModel

@end

@interface EBKUITextFieldTests : XCTestCase {
    UITextField* view;
    TextFieldModel* model;
}

@end

@implementation EBKUITextFieldTests

- (void) setUp {
    [super setUp];
    model = [TextFieldModel new];
    view = [UITextField new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testHidden {
    [model bindKey: @"enabled" view: view viewKey: UITextFieldEnabled];
    [model bindKey: @"hidden" view: view viewKey: UITextFieldHidden];

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

- (void) testString {
    NSString* a = @"a";
    NSString* b = @"b";

    [model bindKey: @"string" view: view viewKey: UITextFieldText];

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

    [model bindKey: @"attributedString" view: view viewKey: UITextFieldAttributedText];

    model.attributedString = a;
    XCTAssertTrue([view.attributedText.debugDescription hasPrefix: @"a"]);
    model.attributedString = b;
    XCTAssertTrue([view.attributedText.debugDescription hasPrefix: @"b"]);
    model.attributedString = a;
    XCTAssertTrue([view.attributedText.debugDescription hasPrefix: @"a"]);

    view.attributedText = b;
    XCTAssertEqualObjects(model.attributedString, b);
    view.attributedText = a;
    XCTAssertEqualObjects(model.attributedString, a);
    view.attributedText = b;
    XCTAssertEqualObjects(model.attributedString, b);
}

@end

