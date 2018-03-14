/*******************************************************************************
 * EBKUISegmentedControl.m                                                     *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"

NSString* UISegmentedControlSelectedSegmentIndex = @"selectedSegmentIndex";
NSString* UISegmentedControlEnabled = @"enabled";
NSString* UISegmentedControlHidden = @"hidden";

@interface EBKUISegmentedControl : UISegmentedControl

@end

@implementation EBKUISegmentedControl

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UISegmentedControlSelectedSegmentIndex: EBKTypeEncode(NSInteger), UISegmentedControlEnabled: EBKTypeEncode(BOOL), UISegmentedControlHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [self addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void) segmentChanged: (id) target {
    NSObject* v = [self boundValueForViewKey: UISegmentedControlSelectedSegmentIndex];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) integerValue] != self.selectedSegmentIndex)
            [self setBoundValue: [NSNumber numberWithInteger: self.selectedSegmentIndex] viewKey: UISegmentedControlSelectedSegmentIndex];
}

- (void) setSelectedSegmentIndex: (NSInteger) selectedSegmentIndex {
    if (super.selectedSegmentIndex != selectedSegmentIndex) {
        [super setSelectedSegmentIndex: selectedSegmentIndex];
        NSObject* v = [self boundValueForViewKey: UISegmentedControlSelectedSegmentIndex];
        if ([v isKindOfClass: [NSNumber class]])
            if ([((NSNumber*) v) integerValue] != self.selectedSegmentIndex)
                [self setBoundValue: [NSNumber numberWithInteger: self.selectedSegmentIndex] viewKey: UISegmentedControlSelectedSegmentIndex];
    }
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UISegmentedControlEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UISegmentedControlEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UISegmentedControlHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UISegmentedControlHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UISegmentedControlSelectedSegmentIndex];
    if ([v isKindOfClass: [NSNumber class]])
        super.selectedSegmentIndex = [((NSNumber*) v) integerValue];

    v = [self boundValueForViewKey: UISegmentedControlEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UISegmentedControlHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UISegmentedControl (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUISegmentedControl.class;
}

@end
