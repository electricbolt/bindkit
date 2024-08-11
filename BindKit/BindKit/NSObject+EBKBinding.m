// NSObject+EBKBinding.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"
#import "EBKInternalBinding.h"
#import <objc/runtime.h>

NSString* EBKBindingException = @"EBKBindingException";

NSString* EBKVersion(void) {
    return @"1.1.0";
}

@implementation NSObject (EBKBinding)

/**
 Returns the instance of EBKInternalBinding associated with this model object.
 */
- (EBKInternalBinding* _Nonnull) internal {
    static const char internalKey;
    EBKInternalBinding* obj = objc_getAssociatedObject(self, &internalKey);
    if (obj == nil) {
        obj = [[EBKInternalBinding alloc] initWithModel: self];
        objc_setAssociatedObject(self, &internalKey, obj, OBJC_ASSOCIATION_RETAIN);
    }
    return obj;
}

- (void) setBoundPropertiesUpdateBlock: (dispatch_block_t _Nullable) updateBlock {
    [[self internal] _setBoundPropertiesUpdateBlock: updateBlock];
}

- (dispatch_block_t _Nullable) boundPropertiesUpdateBlock {
    return [[self internal] _boundPropertiesUpdateBlock];
}

- (void) setBoundPropertiesDelegate: (id<EBKBoundPropertiesDelegate> _Nullable) delegate {
    [[self internal] _setBoundPropertiesDelegate: delegate];
}

- (id<EBKBoundPropertiesDelegate> _Nullable) boundPropertiesDelegate {
    return [[self internal] _boundPropertiesDelegate];
}

- (void) bindSel: (SEL _Nonnull) property view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey {
    return [[self internal] _bindKey: NSStringFromSelector(property) view: view viewKey: viewKey];
}

- (void) bindKey: (NSString* _Nonnull) objectKey view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey {
    // If the keyPath is in format "object.property" remove the "object." prefix.
    NSInteger dotIndex = [objectKey rangeOfString: @"."].location;
    if (dotIndex != NSNotFound)
        objectKey = [objectKey substringFromIndex: dotIndex + 1];

    dotIndex = [viewKey rangeOfString: @"."].location;
    if (dotIndex != NSNotFound)
        viewKey = [viewKey substringFromIndex: dotIndex + 1];

    [[self internal] _bindKey: objectKey view: view viewKey: viewKey];
}

- (void) boundPropertiesDidUpdate {
    // Optional override.
}

- (void) beginUpdatingBoundProperties {
    [[self internal] _beginUpdatingBoundProperties];
}

- (void) endUpdatingBoundProperties {
    [[self internal] _endUpdatingBoundProperties];
}

- (void) updateBoundProperties: (dispatch_block_t _Nonnull) block {
    [[self internal] _updateBoundProperties: block];
}

@end

@implementation NSObject (EBKBindingInternal)

- (void) setBoundValue: (NSObject* _Nullable) value view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey {
    [[self internal] _setBoundValue: value view: view viewKey: viewKey];
}

- (NSObject* _Nullable) boundValueForView: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey {
    return [[self internal] _boundValueForView: view viewKey: viewKey];
}

@end
