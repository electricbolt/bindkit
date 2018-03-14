/*******************************************************************************
 * EBKUITextViewTests.h                                                        *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"

@interface TextViewModel : NSObject {
}

@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL editable;
@property(nonatomic, strong) NSString* string;
@property(nonatomic, assign) NSAttributedString* attributedString;

@end

@implementation TextViewModel

@end

@interface EBKUITextViewTests : XCTestCase {
    UITextView* view;
    TextViewModel* model;
}

@end

@implementation EBKUITextViewTests

- (void) setUp {
    [super setUp];
    model = [TextViewModel new];
    view = [UITextView new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testHidden {
    [model bindKey: @"editable" view: view viewKey: UITextViewEditable];
    [model bindKey: @"hidden" view: view viewKey: UITextViewHidden];

    model.editable = NO;
    model.hidden = NO;
    XCTAssertFalse(view.editable);
    XCTAssertFalse(view.hidden);
    model.editable = YES;
    XCTAssertTrue(view.editable);
    XCTAssertFalse(view.hidden);
    model.editable = NO;
    XCTAssertFalse(view.editable);
    XCTAssertFalse(view.hidden);

    view.editable = YES;
    XCTAssertTrue(model.editable);
    XCTAssertFalse(model.hidden);
    view.editable = NO;
    XCTAssertFalse(model.editable);
    XCTAssertFalse(model.hidden);
    view.editable = YES;
    XCTAssertTrue(model.editable);
    XCTAssertFalse(model.hidden);

    model.editable = NO;
    model.hidden = NO;
    XCTAssertFalse(view.editable);
    XCTAssertFalse(view.hidden);
    model.hidden = YES;
    XCTAssertFalse(view.editable);
    XCTAssertTrue(view.hidden);
    model.hidden = NO;
    XCTAssertFalse(view.editable);
    XCTAssertFalse(view.hidden);

    view.hidden = YES;
    XCTAssertFalse(model.editable);
    XCTAssertTrue(model.hidden);
    view.hidden = NO;
    XCTAssertFalse(model.editable);
    XCTAssertFalse(model.hidden);
    view.hidden = YES;
    XCTAssertFalse(model.editable);
    XCTAssertTrue(model.hidden);
}

- (void) testString {
    NSString* a = @"a";
    NSString* b = @"b";

    [model bindKey: @"string" view: view viewKey: UITextViewText];

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

    [model bindKey: @"attributedString" view: view viewKey: UITextViewAttributedText];

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


