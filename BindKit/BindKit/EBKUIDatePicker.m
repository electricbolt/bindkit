// EBKUIDatePicker.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"

NSString* UIDatePickerDate = @"date";
NSString* UIDatePickerEnabled = @"enabled";
NSString* UIDatePickerHidden = @"hidden";

@interface EBKUIDatePicker : UIDatePicker

@end

@implementation EBKUIDatePicker

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UIDatePickerEnabled: EBKTypeEncode(BOOL), UIDatePickerHidden: EBKTypeEncode(BOOL), UIDatePickerDate: EBKTypeEncode(NSDate)};
}

- (void) viewDidBindWithModel {
    [self addTarget: self action: @selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void) valueChanged: (id) target {
    NSObject* v = [self boundValueForViewKey: UIDatePickerDate];
    if ([v isKindOfClass: [NSDate class]])
        if (![((NSDate*) v) isEqualToDate: self.date])
            [self setBoundValue: self.date viewKey: UIDatePickerDate];
}

- (void) setDate: (NSDate*) date {
    if (![super.date isEqualToDate: date])
        [super setDate: date];
    NSObject* v = [self boundValueForViewKey: UIDatePickerDate];
    if ([v isKindOfClass: [NSDate class]])
        if (![((NSDate*) v) isEqualToDate: date])
            [self setBoundValue: date viewKey: UIDatePickerDate];
}

- (void) setDate: (NSDate*) date animated: (BOOL) animated {
    // Always pass through without checking super.date, as animated parameter may
    // have changed.
    [super setDate: date animated: animated];
    NSObject* v = [self boundValueForViewKey: UIDatePickerDate];
    if ([v isKindOfClass: [NSDate class]])
        if (![((NSDate*) v) isEqualToDate: date])
            [self setBoundValue: date viewKey: UIDatePickerDate];
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UIDatePickerEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UIDatePickerEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UIDatePickerHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UIDatePickerHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UIDatePickerDate];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.date != nil)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
            super.date = nil; // NSDate.date doesn't allow nil
#pragma clang diagnostic pop
    } else if ([v isKindOfClass: [NSDate class]]) {
        if (![super.date isEqualToDate: (NSDate*) v])
            super.date = (NSDate*) v;
    }

    v = [self boundValueForViewKey: UIDatePickerEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UIDatePickerHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UIDatePicker (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUIDatePicker.class;
}

@end
