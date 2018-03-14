/*******************************************************************************
 * EBKPropertyTests.h                                                          *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"
#include <objc/runtime.h>
#import "EBKProperty.h"

@interface EBKPropertyTests : XCTestCase {
}

@property(nonatomic, retain, nonnull) NSString* string;
@property(nonatomic, retain, nonnull, getter=customMutableString) NSMutableString* mutableString;
@property(atomic, weak, nullable, setter=customDictionary:) NSDictionary* dictionary;
@property(atomic, readonly) NSInteger integer;
@property(assign) BOOL boolean;

@end

@implementation EBKPropertyTests

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

/*
 c = char
 i = int
 s = short
 l = long l is treated as a 32-bit quantity on 64-bit programs.
 q = long long
 C = unsigned char
 I = unsigned int
 S = unsigned short
 L = unsigned long
 Q = unsigned long long
 f = float
 d = double
 B = BOOL
 @"object" = Where `object` is NSString, NSAttributedString etc
*/

- (void) testString {
    objc_property_t pt = class_getProperty(self.class, "string");
    EBKProperty* p = [[EBKProperty alloc] initWithObjCProperty: pt];
    XCTAssertFalse([p isReadOnly]);
    XCTAssertEqual([p getter], NSSelectorFromString(@"string"));
    XCTAssertEqual([p setter], NSSelectorFromString(@"setString:"));
    XCTAssertEqualObjects([p name], @"string");
    XCTAssertEqualObjects([p encodedType], @"@\"NSString\"");
}

- (void) testMutableString {
    objc_property_t pt = class_getProperty(self.class, "mutableString");
    EBKProperty* p = [[EBKProperty alloc] initWithObjCProperty: pt];
    XCTAssertFalse([p isReadOnly]);
    XCTAssertEqual([p getter], NSSelectorFromString(@"customMutableString"));
    XCTAssertEqual([p setter], NSSelectorFromString(@"setMutableString:"));
    XCTAssertEqualObjects([p name], @"mutableString");
    XCTAssertEqualObjects([p encodedType], @"@\"NSMutableString\"");
}

- (void) testDictionary {
    objc_property_t pt = class_getProperty(self.class, "dictionary");
    EBKProperty* p = [[EBKProperty alloc] initWithObjCProperty: pt];
    XCTAssertFalse([p isReadOnly]);
    XCTAssertEqual([p getter], NSSelectorFromString(@"dictionary"));
    XCTAssertEqual([p setter], NSSelectorFromString(@"customDictionary:"));
    XCTAssertEqualObjects([p name], @"dictionary");
    XCTAssertEqualObjects([p encodedType], @"@\"NSDictionary\"");
}

- (void) testInteger {
    objc_property_t pt = class_getProperty(self.class, "integer");
    EBKProperty* p = [[EBKProperty alloc] initWithObjCProperty: pt];
    XCTAssertTrue([p isReadOnly]);
    XCTAssertEqual([p getter], NSSelectorFromString(@"integer"));
    XCTAssertEqual([p setter], nil);
    XCTAssertEqualObjects([p name], @"integer");
    XCTAssertEqualObjects([p encodedType], @"q");
}

- (void) testBoolean {
    objc_property_t pt = class_getProperty(self.class, "boolean");
    EBKProperty* p = [[EBKProperty alloc] initWithObjCProperty: pt];
    XCTAssertFalse([p isReadOnly]);
    XCTAssertEqual([p getter], NSSelectorFromString(@"boolean"));
    XCTAssertEqual([p setter], NSSelectorFromString(@"setBoolean:"));
    XCTAssertEqualObjects([p name], @"boolean");
    XCTAssertEqualObjects([p encodedType], @"B");
}

- (void) testGetProperty {
    EBKProperty* p = [EBKProperty object: self property: @""];
    XCTAssertNil(p);

    p = [EBKProperty object: self property: @"unknown"];
    XCTAssertNil(p);

    p = [EBKProperty object: self property: @"string"];
    XCTAssertEqualObjects([p name], @"string");

    p = [EBKProperty object: self property: @"mutableString"];
    XCTAssertEqualObjects([p name], @"mutableString");
}

- (void) testGetPropertyEncoding {
    NSString* e = [EBKProperty object: self propertyTypeEncoding: @""];
    XCTAssertNil(e);

    e = [EBKProperty object: self propertyTypeEncoding: @"unknown"];
    XCTAssertNil(e);

    e = [EBKProperty object: self propertyTypeEncoding: @"string"];
    XCTAssertEqualObjects(e, @"NSString");

    e = [EBKProperty object: self propertyTypeEncoding: @"mutableString"];
    XCTAssertEqualObjects(e, @"NSMutableString");

    e = [EBKProperty object: self propertyTypeEncoding: @"integer"];
    XCTAssertEqualObjects(e, @"q");

    e = [EBKProperty object: self propertyTypeEncoding: @"boolean"];
    XCTAssertEqualObjects(e, @"B");
}

- (void) testUnencodedPropertyType {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    NSString* e = [EBKProperty unencodedPropertyType: nil];
    XCTAssertNil(e);
#pragma clag diagnostic pop

    e = [EBKProperty unencodedPropertyType: @"B"];
    XCTAssertEqualObjects(e, @"B");

    e = [EBKProperty unencodedPropertyType: @"q"];
    XCTAssertEqualObjects(e, @"q");

    e = [EBKProperty unencodedPropertyType: @"{NSString=#}"];
    XCTAssertEqualObjects(e, @"NSString");
}

@end
