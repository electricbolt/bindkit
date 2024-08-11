// EBKDeallocationObserver.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "EBKDeallocationObserver.h"
#import <objc/runtime.h>

@interface EBKDeallocationObserver () {
    dispatch_block_t block;
}

@end

@implementation EBKDeallocationObserver

- (instancetype) initWithBlock: (dispatch_block_t) _block {
    self = [super init];
    if (self) {
        block = [_block copy];
    }
    return self;
}

- (void) dealloc {
    if (block != nil)
        block();
}

+ (void) associate: (NSObject*) object block: (dispatch_block_t) block {
    static const void* deallocContext;
    if (objc_getAssociatedObject(object, &deallocContext) == nil) {
        EBKDeallocationObserver* deallocBlock = [[EBKDeallocationObserver alloc] initWithBlock: block];
        objc_setAssociatedObject(object, &deallocContext, deallocBlock, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
