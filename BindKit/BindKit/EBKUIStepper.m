// EBKUIStepper.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"

NSString* UIStepperValue = @"value";
NSString* UIStepperEnabled = @"enabled";
NSString* UIStepperHidden = @"hidden";

@interface EBKUIStepper : UIStepper

@end

@implementation EBKUIStepper

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UIStepperValue: EBKTypeEncode(double), UIStepperEnabled: EBKTypeEncode(BOOL), UIStepperHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [self addTarget: self action: @selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void) valueChanged: (id) target {
    NSObject* v = [self boundValueForViewKey: UIStepperValue];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) floatValue] != self.value)
            [self setBoundValue: [NSNumber numberWithFloat: self.value] viewKey: UIStepperValue];
}

- (void) setValue: (double) value {
    if (super.value != value)
        [super setValue: value];
    NSObject* v = [self boundValueForViewKey: UIStepperValue];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) doubleValue] != value)
            [self setBoundValue: [NSNumber numberWithDouble: value] viewKey: UIStepperValue];
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UIStepperEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UIStepperEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UIStepperHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UIStepperHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UIStepperValue];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.value != [((NSNumber*) v) doubleValue])
            super.value = [((NSNumber*) v) doubleValue];
    }

    v = [self boundValueForViewKey: UIStepperEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UIStepperHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UIStepper (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUIStepper.class;
}

@end
