/*******************************************************************************
 * EBKUISwitch.m                                                               *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"

NSString* UISwitchOn = @"on";
NSString* UISwitchEnabled = @"enabled";
NSString* UISwitchHidden = @"hidden";

@interface EBKUISwitch : UISwitch

@end

@implementation EBKUISwitch

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UISwitchOn: EBKTypeEncode(BOOL), UISwitchEnabled: EBKTypeEncode(BOOL), UISwitchHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [self addTarget: self action:@selector(switchChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void) switchChanged: (id) target {
    NSObject* v = [self boundValueForViewKey: UISwitchOn];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != self.on)
            [self setBoundValue: [NSNumber numberWithInteger: self.on] viewKey: UISwitchOn];
}

- (void) setOn: (BOOL) on {
    if (super.on != on)
        [super setOn: on];
    NSObject* v = [self boundValueForViewKey: UISwitchOn];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != on)
            [self setBoundValue: [NSNumber numberWithBool: on] viewKey: UISwitchOn];
}

- (void) setOn: (BOOL) on animated: (BOOL) animated {
    if (super.on != on)
        [super setOn: on animated: animated];
    NSObject* v = [self boundValueForViewKey: UISwitchOn];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != on)
            [self setBoundValue: [NSNumber numberWithBool: on] viewKey: UISwitchOn];
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UISwitchEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UISwitchEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UISwitchHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UISwitchHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UISwitchOn];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.on != [((NSNumber*) v) boolValue])
            super.on = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UISwitchEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UISwitchHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UISwitch (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUISwitch.class;
}

@end
