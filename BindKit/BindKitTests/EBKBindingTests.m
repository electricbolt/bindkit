// EBKBindingTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "EBKBinding.h"
#import "EBKProperty.h"

static BOOL modelEqualOperator;
static BOOL viewEqualOperator;

@interface Model : NSObject {
}

@property(nonatomic, retain) NSString* string;
@property(nonatomic, retain) NSString* anotherString;

@end

@implementation Model

- (BOOL) isEqual: (id) object {
    return modelEqualOperator;
}

@end

@interface View : NSObject {
}

@property(nonatomic, assign) BOOL enabled;

@end

@implementation View

- (BOOL) isEqual: (id) object {
    return viewEqualOperator;
}

@end

@interface EBKBindingTests : XCTestCase {
}

@end

@implementation EBKBindingTests

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testBindingEquality {
    Model* m1 = [Model new];
    m1.string = @"string";
    View* v1 = [View new];
    v1.enabled = NO;
    EBKBinding* bm1 = [EBKBinding new];
    bm1.model = m1;
    bm1.modelProperty = [EBKProperty object: m1 property: @"string"];
    bm1.view = v1;
    bm1.viewProperty = @"enabled";

    Model* m2 = [Model new];
    m2.string = @"string";
    View* v2 = [View new];
    v2.enabled = NO;
    EBKBinding* bm2 = [EBKBinding new];
    bm2.model = m2;
    bm2.modelProperty = [EBKProperty object: m2 property: @"string"];
    bm2.view = v2;
    bm2.viewProperty = @"enabled";

    modelEqualOperator = YES;
    viewEqualOperator = YES;
    XCTAssertEqualObjects(bm1, bm2);

    modelEqualOperator = NO;
    XCTAssertNotEqualObjects(bm1, bm2);

    modelEqualOperator = YES;
    viewEqualOperator = NO;
    XCTAssertNotEqualObjects(bm1, bm2);

    viewEqualOperator = YES;
    bm1.modelProperty = [EBKProperty object: m1 property: @"anotherString"];
    XCTAssertNotEqualObjects(bm1, bm2);

    bm1.modelProperty = [EBKProperty object: m1 property: @"string"];
    bm1.viewProperty = @"anotherString";
    XCTAssertNotEqualObjects(bm1, bm2);
}

@end




