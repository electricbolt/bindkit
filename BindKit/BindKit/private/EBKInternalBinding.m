/*******************************************************************************
 * EBKInternalBinding.m                                                        *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "EBKInternalBinding.h"
#import "EBKInternalBinding.h"
#import "NSObject+EBKBinding.h"
#import "EBKBinding.h"
#import "EBKView+EBKDynamicSubclass.h"
#import <objc/runtime.h>
#import "EBKDeallocationObserver.h"

@interface EBKInternalBinding () {
    /**
     The instance of the model that we are bound to.
     We use EBKDeallocationObserver.associate:block: to wrap this `weak`
     variable to tell us when the model instance is being deallocated. This
     variable is set to nil during deallocation.
     */
    __weak NSObject* weakModel;
    
    /**
     The instance of the model that we are bound to.
     Used during deallocation to remove the KVO bindings as it is not set to
     nil like weakModel is.
     */
    __unsafe_unretained NSObject* unsafeModel;
    
    /**
     Properties that have been bound to views.
     */
    NSMutableArray<EBKBinding*>* bindings;
    
    /**
     YES if model property change has been detected in KVO.
     */
    BOOL insidePropertyChangedGuard;
    
    /**
     YES if we're inside fireUpdate - if we trigger another KVO, it won't
     fireUpdate again.
     */
    BOOL insideFireUpdateGuard;
    
    /**
     Name of property that is being set inside of a view.
     */
    NSString* boundPropertyGuard;
    
    /**
     When >0 coalescing property updates.
     */
    NSInteger updateCount;
    
    /**
     non-nil if update block is specified.
     */
    dispatch_block_t boundPropertiesUpdateBlock;
    
    /**
     non-nil if delegate is specified.
     */
    __weak id<EBKBoundPropertiesDelegate> boundPropertiesDelegate;
}

@end

@implementation EBKInternalBinding

- (instancetype) initWithModel: (NSObject* _Nonnull) _model {
    self = [super init];
    if (self) {
        weakModel = _model;
        unsafeModel = _model;
        bindings = [NSMutableArray new];
    }
    return self;
}

- (void) dealloc {
    EBKDEBUG(@"Removing KVO - dealloc");
    [self removeKVO];
}

- (void) removeKVO {
    // Notes from the `objc_storeWeak` function used by the compiler to access
    // weak variables:
    // "If value is a null pointer or the object to which it points has begun
    // deallocation, object is assigned null and unregistered as a __weak object.
    // Otherwise, object is registered as a __weak object or has its registration
    // updated to point to value."
    // Because deallocation has already begun, the weakModel variable has been
    // set to nil. We can use unsafeModel - which has been `assigned` during this
    // deallocation method in order to remove KVO.
    if (unsafeModel != nil) {
        for (EBKBinding* binding in bindings) {
            @try {
                EBKDEBUG(@"Removing KVO from object '%@' property '%@'", unsafeModel, binding.modelProperty.name);
                [unsafeModel removeObserver: self forKeyPath: binding.modelProperty.name];
            } @catch (NSException* __unused exception) {
                // do nothing.
            }
        }
        unsafeModel = nil;
    }
}

- (void) _setBoundPropertiesDelegate: (id<EBKBoundPropertiesDelegate>) _boundPropertiesDelegate {
    boundPropertiesDelegate = _boundPropertiesDelegate;
    if (boundPropertiesDelegate != nil)
        [boundPropertiesDelegate boundPropertiesDidUpdate];
}

- (id<EBKBoundPropertiesDelegate>) _boundPropertiesDelegate {
    return boundPropertiesDelegate;
}

- (void) _setBoundPropertiesUpdateBlock: (dispatch_block_t) _boundPropertiesUpdateBlock {
    boundPropertiesUpdateBlock = [_boundPropertiesUpdateBlock copy];
    if (boundPropertiesUpdateBlock != nil)
        boundPropertiesUpdateBlock();
}

- (dispatch_block_t) _boundPropertiesUpdateBlock {
    return boundPropertiesUpdateBlock;
}

static const void* observeContext;

- (void) _bindKey: (NSString* _Nonnull) modelKey view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey {
    if (modelKey == nil)
        @throw [NSException exceptionWithName: EBKBindingException reason: @"modelKey parameter cannot be nil" userInfo: nil];
    if (view == nil)
        @throw [NSException exceptionWithName: EBKBindingException reason: @"view parameter cannot be nil" userInfo: nil];
    if (viewKey == nil)
        @throw [NSException exceptionWithName: EBKBindingException reason: @"viewKey parameter cannot be nil" userInfo: nil];

    EBKBinding* binding = [EBKBinding new];
    binding.model = weakModel;
    binding.modelProperty = [EBKProperty object: weakModel property: modelKey];
    binding.view = view;
    binding.viewProperty = viewKey;
    
    NSString* modelPropertyTypeEncoding = [EBKProperty unencodedPropertyType: binding.modelProperty.encodedType];
    
    if (binding.modelProperty == nil)
        @throw [NSException exceptionWithName: EBKBindingException reason: [NSString stringWithFormat: @"Model '%@' property with name '%@' not found", NSStringFromClass(weakModel.class), modelKey] userInfo: nil];
    if (binding.modelProperty.getter == nil)
        @throw [NSException exceptionWithName: EBKBindingException reason: [NSString stringWithFormat: @"Model '%@' property getter with name '%@' is not defined", NSStringFromClass(weakModel.class), modelKey] userInfo: nil];
    if (binding.modelProperty.setter == nil)
        @throw [NSException exceptionWithName: EBKBindingException reason: [NSString stringWithFormat: @"Model '%@' property setter with name '%@' is not defined", NSStringFromClass(weakModel.class), modelKey] userInfo: nil];
    if (binding.modelProperty.isReadOnly)
        @throw [NSException exceptionWithName: EBKBindingException reason: [NSString stringWithFormat: @"Model '%@' property with name '%@' is read only", NSStringFromClass(weakModel.class), modelKey] userInfo: nil];
    if ([bindings containsObject: binding]) {
        NSString* reason = [NSString stringWithFormat:
            @"Duplicate binding exists with model '%@' property name '%@' and view '%@' property name '%@'",
            NSStringFromClass(weakModel.class), modelKey, NSStringFromClass(view.class), viewKey];
        @throw [NSException exceptionWithName: EBKBindingException reason: reason  userInfo: nil];
    }

    [bindings addObject: binding];

    // Add KVO to model property
    EBKDEBUG(@"Adding KVO to model '%@' property '%@'", binding.model, binding.modelProperty.name);
    [binding.model addObserver: self forKeyPath: binding.modelProperty.name options: NSKeyValueObservingOptionNew context: &observeContext];
    [EBKDeallocationObserver associate: weakModel block: ^{
        EBKDEBUG(@"Removing KVO - dealloc block");
        [self removeKVO];
    }];
    
    // Dynamically subclass view
    [binding.view bindModel: binding.model];
    
    NSDictionary<NSString*,NSString*>* bindableProperties = [binding.view bindableProperties];
    BOOL found = NO;
    for (NSString* bindableProperty in bindableProperties) {
        // Check if any of the properties defined in the view subclass match the property attempting to be bound.
        if ([bindableProperty isEqualToString: viewKey]) {
            // Ensure property types are compatible.
            NSString* bindablePropertyTypeEncoding = [bindableProperties objectForKey: bindableProperty];
            bindablePropertyTypeEncoding = [EBKProperty unencodedPropertyType: bindablePropertyTypeEncoding];
            if (![modelPropertyTypeEncoding isEqualToString: bindablePropertyTypeEncoding]) {
                NSString* reason = [NSString stringWithFormat:
                    @"Model '%@' property with name '%@' unsupported type '%@' expecting '%@'",
                    NSStringFromClass(weakModel.class), modelKey, modelPropertyTypeEncoding, bindablePropertyTypeEncoding];
                @throw [NSException exceptionWithName: EBKBindingException reason: reason userInfo: nil];
            }
            found = YES;
            break;
        }
    }
    if (found == NO) {
        NSString* reason = [NSString stringWithFormat: @"View '%@' unsupported property '%@'", NSStringFromClass(view.class), viewKey];
        @throw [NSException exceptionWithName: EBKBindingException reason: reason userInfo: nil];
    }

    insidePropertyChangedGuard = YES;
    [binding.view updateViewFromBoundModel];
    insidePropertyChangedGuard = NO;
}

- (void) observeValueForKeyPath: (NSString*) keyPath ofObject: (id) object change: (NSDictionary*) change context: (void*) context {
    if (context == &observeContext) {
        EBKDEBUG(@"observeValueForKeyPath: '%@'", keyPath);
        for (EBKBinding* binding in bindings) {
            if (binding.model == object && [binding.modelProperty.name isEqualToString: keyPath]) {
                if (![boundPropertyGuard isEqualToString: keyPath]) {
                    insidePropertyChangedGuard = YES;
                    [binding.view updateViewFromBoundModel];
                    insidePropertyChangedGuard = NO;
                    [self _fireUpdate];
                }
            }
        }
    } else
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
}

- (void) _setBoundValue: (NSObject* _Nullable) value view: (EBKView* _Nullable) view viewKey: (NSString* _Nonnull) viewKey {
    if (insidePropertyChangedGuard)
        return;

    for (EBKBinding* binding in bindings) {
        if (binding.view == view && [binding.viewProperty isEqualToString: viewKey]) {
            boundPropertyGuard = viewKey;
            [binding.model setValue: value forKey: binding.modelProperty.name];
            [self _fireUpdate];
            boundPropertyGuard = nil;
            return;
        }
    }
}

- (NSObject* _Nullable) _boundValueForView: (EBKView* _Nullable) view viewKey: (NSString* _Nonnull) viewKey {
    for (EBKBinding* binding in bindings) {
        if (binding.view == view && [binding.viewProperty isEqualToString: viewKey]) {
            NSObject* v = [binding.model valueForKey: binding.modelProperty.name];
            if (v == nil)
                return [NSNull null];
            else
                return v;
        }
    }
    return nil;
}

- (void) _beginUpdatingBoundProperties {
    updateCount++;
}

- (void) _endUpdatingBoundProperties {
    updateCount--;
    if (updateCount < 0)
        EBKERROR(@"Mismatched calls to beginUpdatingBoundProperties & endUpdatingBoundProperties");
    if (updateCount == 0)
        [self _fireUpdate];
}

- (void) _updateBoundProperties: (dispatch_block_t) block {
    [self _beginUpdatingBoundProperties];
    if (block != nil)
        block();
    [self _endUpdatingBoundProperties];
}

- (void) _fireUpdate {
    if (updateCount > 0)
        return;
    if (insideFireUpdateGuard == YES)
        return;
    insideFireUpdateGuard = YES;
    [weakModel boundPropertiesDidUpdate];
    if (boundPropertiesUpdateBlock != nil)
        boundPropertiesUpdateBlock();
    [boundPropertiesDelegate boundPropertiesDidUpdate];
    insideFireUpdateGuard = NO;
}

@end
