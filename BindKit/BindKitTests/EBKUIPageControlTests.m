// EBKUIPageControlTests.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import XCTest;
#import "BindKit.h"

@interface PageControlModel : NSObject {
}

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSInteger numberOfPages;

@end

@implementation PageControlModel

@end

@interface EBKUIPageControlTests : XCTestCase {
    UIPageControl* view;
    PageControlModel* model;
}

@end

@implementation EBKUIPageControlTests

- (void) setUp {
    [super setUp];
    model = [PageControlModel new];
    view = [UIPageControl new];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testEnabledHidden {
    [model bindKey: @"enabled" view: view viewKey: UIPageControlEnabled];
    [model bindKey: @"hidden" view: view viewKey: UIPageControlHidden];

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

- (void) testCurrentPageNumberOfPages {
    [model bindKey: @"currentPage" view: view viewKey: UIPageControlCurrentPage];
    [model bindKey: @"numberOfPages" view: view viewKey: UIPageControlNumberOfPages];

    model.numberOfPages = 5;
    model.currentPage = 2;
    XCTAssertEqual(view.currentPage, 2);
    XCTAssertEqual(view.numberOfPages, 5);
    model.currentPage = 3;
    XCTAssertEqual(view.currentPage, 3);
    XCTAssertEqual(view.numberOfPages, 5);
    model.numberOfPages = 4;
    XCTAssertEqual(view.currentPage, 3);
    XCTAssertEqual(view.numberOfPages, 4);

    view.currentPage = 2;
    XCTAssertEqual(model.currentPage, 2);
    XCTAssertEqual(model.numberOfPages, 4);
    view.numberOfPages = 3;
    XCTAssertEqual(model.currentPage, 2);
    XCTAssertEqual(model.numberOfPages, 3);
    view.currentPage = 1;
    XCTAssertEqual(model.currentPage, 1);
    XCTAssertEqual(model.numberOfPages, 3);
}

@end



