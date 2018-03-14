/*******************************************************************************
 * EBKView+EBKDynamicSubclass.m                                                *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"
#import "EBKView+EBKDynamicSubclass.h"
#import "NSObject+EBKBinding.h"
#import "EBKView+EBKSubclass.h"
#import <objc/runtime.h>

@implementation EBKView (EBKDynamicSubclass)

static const char boundObjectKey;

- (NSObject*) boundObject {
    return objc_getAssociatedObject(self, &boundObjectKey);
}

- (void) setBoundValue: (NSObject*) value viewKey: (NSString*) viewKey {
    [[self boundObject] setBoundValue: value view: self viewKey: viewKey];
}

- (NSObject*) boundValueForViewKey: (NSString*) viewKey {
    return [[self boundObject] boundValueForView: self viewKey: viewKey];
}

- (void) validateProperty: (NSString*) name type: (NSString*) propertyType {
    // Override in each EBKUI* class to validate the property name is valid for the view.
}

- (NSDictionary<NSString*,NSString*>*) bindableProperties {
    // Override in each EBKUI* class to return list of valid property names and types for the view.
    @throw [NSException exceptionWithName: EBKBindingException reason: @"bindableProperties must be implemented" userInfo: nil];
}

- (void) viewDidBindWithModel {
    // Optionally override in each EBKUI* class to capture changes to it's state.
}

- (void) updateViewFromBoundModel {
    // Override in each EBKUI* class to update it's state from the
    // bound objects properties.
    @throw [NSException exceptionWithName: EBKBindingException reason: @"updateViewFromBoundObject must be implemented" userInfo: nil];
}

@end

@implementation EBKView (EBKDynamicSubclassInternal)

- (void) bindModel: (NSObject* _Nonnull) obj {
    if ([self respondsToSelector: @selector(EBKDynamicSubclass)]) {
        Class class = [self EBKDynamicSubclass];
        objc_setAssociatedObject(self, &boundObjectKey, obj, OBJC_ASSOCIATION_ASSIGN);
        if ([class EBKSubclassInstance: self])
            [self viewDidBindWithModel];
    } else
        @throw [NSException exceptionWithName: EBKBindingException reason:
            [NSString stringWithFormat: @"View %@ does not have a dynamic subclass implemented", self] userInfo: nil];
}

@end

@implementation EBKView (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    // Override in each UI* class to return the EBKUI* subclass
    return nil;
}

@end
