/*******************************************************************************
 * EBKInternalBinding.h                                                        *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

@import Foundation;
#import "BindKit.h"

/**
 Internal class used by NSObject+EBKBinding.
 */

@interface EBKInternalBinding : NSObject

- (instancetype _Nonnull) initWithModel: (NSObject* _Nonnull) model;

/**
 This delegate will be called when any bound properties are updated.
 */
- (void) _setBoundPropertiesDelegate: (id<EBKBoundPropertiesDelegate> _Nonnull) boundPropertiesDelegate;
- (id<EBKBoundPropertiesDelegate> _Nonnull) _boundPropertiesDelegate;

/**
 This update block will be called when any bound properties are updated.
 */
- (void) _setBoundPropertiesUpdateBlock: (dispatch_block_t _Nonnull) boundPropertiesUpdateBlock;
- (dispatch_block_t _Nonnull) _boundPropertiesUpdateBlock;

/**
 Binds a property to a view.
 */
- (void) _bindKey: (NSString* _Nonnull) modelKey view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey;

/**
 If the view property is mapped to an object property, then the value is
 set onto the object against the mapped object property.
 */
- (void) _setBoundValue: (NSObject* _Nullable) value view: (EBKView* _Nullable) view viewKey: (NSString* _Nonnull) viewKey;

/**
 If the view property is mapped to an object property, then the value is
 retrieved from the object against the mapped object property. If the value is
 non-nil then the value is returned. If the value is nil, the [NSNull null] is
 returned. If the view property is not mapped to an object property, then nil
 is returned.
 */
- (NSObject* _Nullable) _boundValueForView: (EBKView* _Nullable) view viewKey: (NSString* _Nonnull) viewKey;

/**
 These methods signals to the system that you are about to make modifications to
 bound properties. Any modifications to properties are coalesced,
 boundPropertiesUpdateBlock, boundPropertiesDelegate, boundPropertiesDidUpdate
 are called once.
 */
- (void) _beginUpdatingBoundProperties;
- (void) _endUpdatingBoundProperties;
- (void) _updateBoundProperties: (dispatch_block_t _Nonnull) block;

/**
 Calls the boundPropertiesDidUpdate method, boundPropertiesUpdateBlock and
 boundPropertiesDelegate (in that order) if modifications aren't being coalesced.
 */
- (void) _fireUpdate;

@end
