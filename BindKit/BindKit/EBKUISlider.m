// EBKUISlider.m
// BindKit Copyright (c) 2018; Electric Bolt Limited.

#import "BindKit.h"

NSString* UISliderValue = @"value";
NSString* UISliderEnabled = @"enabled";
NSString* UISliderHidden = @"hidden";

@interface EBKUISlider : UISlider

@end

@implementation EBKUISlider

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UISliderValue: EBKTypeEncode(float), UISliderEnabled: EBKTypeEncode(BOOL), UISliderHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [self addTarget:self action:@selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void) sliderChanged: (id) target {
    NSObject* v = [self boundValueForViewKey: UISliderValue];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) floatValue] != self.value)
            [self setBoundValue: [NSNumber numberWithFloat: self.value] viewKey: UISliderValue];
}

- (void) setValue: (float) value animated: (BOOL) animated {
    // Always pass through without checking super.value, as animated parameter
    // may have changed.
    [super setValue: value animated: animated];
    [self setBoundValue: [NSNumber numberWithFloat: value] viewKey: UISliderValue];
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UISliderEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UISliderEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UISliderHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UISliderHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UISliderValue];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.value != [((NSNumber*) v) floatValue])
            super.value = [((NSNumber*) v) floatValue];
    }

    v = [self boundValueForViewKey: UISliderEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UISliderHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UISlider (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUISlider.class;
}

@end
