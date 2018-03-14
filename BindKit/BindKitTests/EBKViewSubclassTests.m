/*******************************************************************************
 * EBKViewSubclassTests.h                                                      *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import XCTest;
#import "BindKit.h"
#include <objc/runtime.h>
#import "EBKView+EBKSubclass.h"

@interface SubclassingArbitaryObject: EBKView {
}

@end

@interface EBKUISubclassingArbitaryObject: SubclassingArbitaryObject {
}

@end

@implementation SubclassingArbitaryObject

 - (Class) EBKDynamicSubclass {
    return EBKUISubclassingArbitaryObject.class;
 }

@end

@implementation EBKUISubclassingArbitaryObject

@end

@interface EBKViewSubclassTests : XCTestCase {
}

@end

@implementation EBKViewSubclassTests

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testSubclass {
    Class c;
    SubclassingArbitaryObject* ao = [SubclassingArbitaryObject new];
    XCTAssertThrows(c = ao.EBKClass); // invalid selector
    Class class = [ao EBKDynamicSubclass];

    // Dynamically subclass
    BOOL result = [class EBKSubclassInstance: ao];
    XCTAssertNoThrow(ao.EBKClass); // EBKClass available on subclass
    XCTAssertTrue(result); // was subclassed - returns YES
    XCTAssertTrue([ao isKindOfClass: [SubclassingArbitaryObject class]]);

    // Already dynamically subclassed
    result = [class EBKSubclassInstance: ao];
    XCTAssertNoThrow(ao.EBKClass); // EBKClass available on subclass
    XCTAssertFalse(result); // already subclassed - returns NO
    XCTAssertTrue([ao isKindOfClass: [SubclassingArbitaryObject class]]);
}

@end



