/*******************************************************************************
 * EBKView+EBKDynamicSubclass.h                                               *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import Foundation;

@interface EBKView (EBKDynamicSubclassInternal)

/**
 Called by EKInternalBinding._bindKey:view:viewKey:
 */
- (void) bindModel: (NSObject* _Nonnull) obj;

@end
