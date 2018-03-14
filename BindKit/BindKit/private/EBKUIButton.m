/*******************************************************************************
 * EBKUIButton.m                                                               *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"

NSString* UIButtonEnabled = @"enabled";
NSString* UIButtonHidden = @"hidden";

@interface EBKUIButton : UIButton

@end

@implementation EBKUIButton

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UIButtonEnabled: EBKTypeEncode(BOOL), UIButtonHidden: EBKTypeEncode(BOOL)};
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UIButtonEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UIButtonEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UIButtonHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UIButtonHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UIButtonEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UIButtonHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UIButton (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUIButton.class;
}

@end
