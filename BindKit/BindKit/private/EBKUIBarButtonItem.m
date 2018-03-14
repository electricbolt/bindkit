/*******************************************************************************
 * EBKUIBarButtonItem.m                                                        *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"

NSString* UIBarButtonItemEnabled = @"enabled";

@interface EBKUIBarButtonItem : UIBarButtonItem

@end

@implementation EBKUIBarButtonItem

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UIBarButtonItemEnabled: EBKTypeEncode(BOOL)};
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UIBarButtonItemEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UIBarButtonItemEnabled];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UIBarButtonItemEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UIBarButtonItem (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUIBarButtonItem.class;
}

@end
