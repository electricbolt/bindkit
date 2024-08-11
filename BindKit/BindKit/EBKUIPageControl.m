// EBKUIPageControl.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"

NSString* UIPageControlCurrentPage = @"currentPage";
NSString* UIPageControlNumberOfPages = @"numberOfPages";
NSString* UIPageControlEnabled = @"enabled";
NSString* UIPageControlHidden = @"hidden";

@interface EBKUIPageControl : UIPageControl

@end

@implementation EBKUIPageControl

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UIPageControlCurrentPage: EBKTypeEncode(NSInteger), UIPageControlNumberOfPages: EBKTypeEncode(NSInteger), UIPageControlEnabled: EBKTypeEncode(BOOL), UIPageControlHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [self addTarget: self action: @selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void) valueChanged: (id) target {
    NSObject* v = [self boundValueForViewKey: UIPageControlCurrentPage];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) integerValue] != self.currentPage)
            [self setBoundValue: [NSNumber numberWithFloat: self.currentPage] viewKey: UIPageControlCurrentPage];
}

- (void) setCurrentPage: (NSInteger) currentPage {
    if (super.currentPage != currentPage)
        [super setCurrentPage: currentPage];
    NSObject* v = [self boundValueForViewKey: UIPageControlCurrentPage];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) integerValue] != currentPage)
            [self setBoundValue: [NSNumber numberWithInteger: currentPage] viewKey: UIPageControlCurrentPage];
}

- (void) setNumberOfPages: (NSInteger) numberOfPages {
    if (super.numberOfPages != numberOfPages)
        [super setCurrentPage: numberOfPages];
    NSObject* v = [self boundValueForViewKey: UIPageControlNumberOfPages];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) integerValue] != numberOfPages)
            [self setBoundValue: [NSNumber numberWithInteger: numberOfPages] viewKey: UIPageControlNumberOfPages];
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UIPageControlEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UIPageControlEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UIPageControlHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UIPageControlHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UIPageControlCurrentPage];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.currentPage != [((NSNumber*) v) integerValue])
            super.currentPage = [((NSNumber*) v) integerValue];
    }

    v = [self boundValueForViewKey: UIPageControlNumberOfPages];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.numberOfPages != [((NSNumber*) v) integerValue])
            super.numberOfPages = [((NSNumber*) v) integerValue];
    }

    v = [self boundValueForViewKey: UIPageControlEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UIPageControlHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UIPageControl (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUIPageControl.class;
}

@end
