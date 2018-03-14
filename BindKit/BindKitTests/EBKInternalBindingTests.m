/*******************************************************************************
 * EBKInternalBindingTests.h                                                   *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "EBKInternalBinding.h"
#include "EBKView+EBKSubclass.h"

@interface IBTModel : NSObject {
}

@property(nonatomic, assign) BOOL boolean;
@property(nonatomic, strong) UIImage* image;
@property(nonatomic, strong) NSString* string;
@property(nonatomic, readonly) NSString* readOnlyString;

@end

@implementation IBTModel

- (NSString*) readOnlyString {
    return @"";
}

@end

@interface EBKInternalBindingTests : XCTestCase {
    IBTModel* model;
    UISwitch* view;
    EBKInternalBinding* binding;
}

@end

@implementation EBKInternalBindingTests

- (void) setUp {
    [super setUp];
    model = [IBTModel new];
    view = [UISwitch new];
    binding = [[EBKInternalBinding alloc] initWithModel: model];
}

- (void) tearDown {
    [super tearDown];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
- (void) testParameters {
    @try {
        [binding _bindKey: nil view: nil viewKey: nil];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"modelKey parameter cannot be nil");
    }
    @try {
        [binding _bindKey: @"modelKey" view: nil viewKey: nil];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"view parameter cannot be nil");
    }
    @try {
        [binding _bindKey: @"modelKey" view: view viewKey: nil];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"viewKey parameter cannot be nil");
    }
}
#pragma clag diagnostic pop

- (void) testProperties {
    @try {
        [binding _bindKey: @"unknown" view: view viewKey: @""];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"Model 'IBTModel' property with name 'unknown' not found");
    }
    // Can't test no getter.
    @try {
        [binding _bindKey: @"readOnlyString" view: view viewKey: @""];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"Model 'IBTModel' property setter with name 'readOnlyString' is not defined");
    }
    // Can't test read only.
}

- (void) testDuplicateBinding {
    XCTAssertNoThrow([binding _bindKey: @"boolean" view: view viewKey: @"enabled"]);
    @try {
        [binding _bindKey: @"boolean" view: view viewKey: @"enabled"];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"Duplicate binding exists with model 'IBTModel' property name 'boolean' and view 'UISwitch' property name 'enabled'");
    }
}

- (void) testIncompatibleModelAndViewProperties {
    @try {
        [binding _bindKey: @"string" view: view viewKey: @"enabled"];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"Model 'IBTModel' property with name 'string' unsupported type 'NSString' expecting 'B'");
    }

    @try {
        [binding _bindKey: @"image" view: view viewKey: @"onImage"];
        XCTFail(@"Should have thrown an EBKBindingException");
    } @catch(NSException* e) {
        XCTAssertEqualObjects([e reason], @"View 'UISwitch' unsupported property 'onImage'");
    }
}

@end





