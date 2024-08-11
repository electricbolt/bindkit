// NSObject+EBKBinding.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import UIKit;

@interface NSObject (EBKBindingInternal)

/**
 Called by EBKView+EBKDynamicSubclass setBoundValue:viewKey:
 */
- (void) setBoundValue: (NSObject* _Nullable) value view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey;

/**
 Called by EBKView+EBKDynamicSubclass boundValue:viewKey:
 */
- (NSObject* _Nullable) boundValueForView: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey;

@end
