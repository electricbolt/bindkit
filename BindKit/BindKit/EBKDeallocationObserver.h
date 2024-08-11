// EBKDeallocationObserver.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import Foundation;

@interface EBKDeallocationObserver : NSObject

/**
 @brief Calls the block provided when the object has been deallocated.
 */
+ (void) associate: (NSObject* _Nonnull) object block: (dispatch_block_t _Nonnull) block;

@end
