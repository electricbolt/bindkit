// EBKMulticastDelegate.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"

@implementation EBKMulticastDelegate

- (void) forwardInvocation: (NSInvocation*) anInvocation {
    if ([_primaryDelegate respondsToSelector:[anInvocation selector]])
        [anInvocation invokeWithTarget: _primaryDelegate];
    if ([_secondaryDelegate respondsToSelector:[anInvocation selector]])
        [anInvocation invokeWithTarget: _secondaryDelegate];
}

- (BOOL) respondsToSelector: (SEL) aSelector {
    if ([super respondsToSelector: aSelector])
        return YES;
    if ([_primaryDelegate respondsToSelector: aSelector])
        return YES;
    if ([_secondaryDelegate respondsToSelector: aSelector])
        return YES;
    return NO;
}

- (NSMethodSignature*) methodSignatureForSelector: (SEL) aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector: aSelector];
    if (!signature) {
        if ([_primaryDelegate respondsToSelector: aSelector])
            return [_primaryDelegate methodSignatureForSelector: aSelector];
        if ([_secondaryDelegate respondsToSelector: aSelector])
            return [_secondaryDelegate methodSignatureForSelector: aSelector];
    }
    return signature;
}

@end
