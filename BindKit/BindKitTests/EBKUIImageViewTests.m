// EBKUIImageViewTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@interface ImageModel : NSObject {
}

@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, strong) UIImage* image;

@end

@implementation ImageModel

@end

@interface EBKUIImageViewTests : XCTestCase {
    UIImageView* view;
    ImageModel* model;
    UIImage* cat;
    UIImage* dog;
}

@end

@implementation EBKUIImageViewTests

- (void) setUp {
    [super setUp];
    model = [ImageModel new];
    view = [UIImageView new];

    NSBundle* bundle = [NSBundle bundleForClass: [self class]];
    NSString* path = [bundle pathForResource: @"cat" ofType: @"jpg"];
    cat = [UIImage imageWithContentsOfFile:path];

    path = [bundle pathForResource: @"dog" ofType: @"jpg"];
    dog = [UIImage imageWithContentsOfFile:path];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testHidden {
    model.hidden = NO;

    [model bindKey: @"hidden" view: view viewKey: UIImageViewHidden];

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

- (void) testImage {
    model.image = cat;

    [model bindKey: @"image" view: view viewKey: UIImageViewImage];

    model.image = cat;
    XCTAssertEqual(view.image.size.width, cat.size.width);
    model.image = dog;
    XCTAssertEqual(view.image.size.width, dog.size.width);
    model.image = cat;
    XCTAssertEqual(view.image.size.width, cat.size.width);

    view.image = dog;
    XCTAssertEqual(model.image.size.width, dog.size.width);
    view.image = cat;
    XCTAssertEqual(model.image.size.width, cat.size.width);
    view.image = dog;
    XCTAssertEqual(model.image.size.width, dog.size.width);
}

@end

