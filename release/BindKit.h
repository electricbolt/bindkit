/*******************************************************************************
 * BindKit.h                                                                   *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#ifndef BindKit_h
#define BindKit_h

#import <UIKit/UIKit.h>

// Not all views inherit from UIView (e.g. UIBarButtonItem).
#define EBKView NSObject

@protocol EBKBoundPropertiesDelegate

- (void) boundPropertiesDidUpdate;

@end

/**
 @brief Properties of model objects can be bound to user interface elements to
 access and modify their values.
 */
@interface NSObject (EBKBinding)

/**
 @brief This update block will be called when any of the model's bound
 properties are updated.
 @remark See also boundPropertiesDelegate and boundPropertiesDidUpdate.
 */
@property(nonatomic, copy, nullable) dispatch_block_t boundPropertiesUpdateBlock;

/**
 @brief This delegate will be called when any of the model's bound properties are
 updated.

 @remark See also boundPropertiesUpdateBlock and boundPropertiesDidUpdate.
 */
@property(nonatomic, weak, nullable) id<EBKBoundPropertiesDelegate> boundPropertiesDelegate;

/**
 @abstract This method will be called when any of the model's bound properties
 are updated.

 @remark See also boundPropertiesUpdateBlock and boundPropertiesDelegate.
 */
- (void) boundPropertiesDidUpdate;

/**
 @abstract This method signals to the system that you are about to make
 modifications to model's bound properties.

 @discussion Any modifications to properties are coalesced. When you have
 finished making modifications, call the endUpdatingBoundProperties method.
 boundPropertiesDidUpdate, boundPropertiesDelegate, boundPropertiesUpdateBlock
 are called once (in that order). Calls to beginUpdatingBoundProperties must be
 balanced with endUpdatingBoundProperties.

 @remark See also updateBoundProperties.
 */
- (void) beginUpdatingBoundProperties;
- (void) endUpdatingBoundProperties;

/**
 @abstract This method coalesces all modifications to the model's bound properties made
 within the block.

 @discussion When the block completes, boundPropertiesDidUpdate,
 boundPropertiesDelegate, boundPropertiesUpdateBlock are called once (in that
 order).

 @remark See also beginUpdatingBoundProperties.
 */
- (void) updateBoundProperties: (dispatch_block_t _Nonnull) block;

/**
 @abstract Binds a model property to a view property using selectors.

 @discussion Objective-C usage example:
 @code
 [model bindSel: @selector(nameStr) view: nameTextField viewSel: @selector(text)];
 @endcode

 @param modelSel Selector for the model property to bind. Must not be nil.
 @param view View to bind with the model. Must not be nil.
 @param viewKey Keypath string for the view property to bind. Must not be nil. e.g. UISwitchEnabled -> "enabled"

 @throws EBKBindingException will be thrown if the following programmer errors
 are detected during the binding process:
 "Model property parameter cannot be nil",
 "View parameter cannot be nil",
 "View property parameter cannot be nil",
 "Model [model] property with name [name] not found",
 "Model [model] property getter with name [name] is not defined",
 "Model [model] property setter with name [name] is not defined",
 "Model [model] property with name [name] is read only",
 "Duplicate binding exists with model [model] property name [name] and view [view] property name [name]",
 "Model [model] property with name [name] unsupported type [type] expecting [type]",
 "View [view] unsupported property [name]"

 @remark See also beginUpdatingBoundProperties.
 */
- (void) bindSel: (SEL _Nonnull) modelSel view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey;

/*!
 @brief Binds a model property to a view property using key paths.

 @discussion
 Swift usage example:
 @code
 model.bindKey(#keyPath(model.name) toView: nameTextField viewKey: UITextFieldText)
 @endcode

 @param modelKey Keypath string for the model property to bind. Must not be nil.
 @param view View to bind with the model. Must not be nil.
 @param viewKey Keypath string for the view property to bind. Must not be nil. e.g. UISwitchEnabled -> "enabled"

 @remark See also bindSel:toView:viewSel:
 */
- (void) bindKey: (NSString* _Nonnull) modelKey view: (EBKView* _Nonnull) view viewKey: (NSString* _Nonnull) viewKey;

@end

#pragma mark Supported out-of-the-box bindable views and properties

NS_ASSUME_NONNULL_BEGIN
extern NSString* UIBarButtonItemEnabled; // BOOL

extern NSString* UIButtonEnabled; // BOOL
extern NSString* UIButtonHidden; // BOOL

extern NSString* UIDatePickerDate; // NSDate
extern NSString* UIDatePickerEnabled; // BOOL
extern NSString* UIDatePickerHidden; // BOOL

extern NSString* UIImageViewImage; // UIImage
extern NSString* UIImageViewHidden; // BOOL

extern NSString* UILabelText; // NSString
extern NSString* UILabelAttributedText; // NSAttributedString
extern NSString* UILabelHidden; // BOOL

extern NSString* UIPageControlCurrentPage; // NSInteger
extern NSString* UIPageControlNumberOfPages; // NSInteger
extern NSString* UIPageControlEnabled; // BOOL
extern NSString* UIPageControlHidden; // BOOL

extern NSString* UISegmentedControlSelectedSegmentIndex; // NSInteger
extern NSString* UISegmentedControlEnabled; // BOOL
extern NSString* UISegmentedControlHidden; // BOOL

extern NSString* UISliderValue; // float
extern NSString* UISliderEnabled; // BOOL
extern NSString* UISliderHidden; // BOOL

extern NSString* UIStepperValue; // double
extern NSString* UIStepperEnabled; // BOOL
extern NSString* UIStepperHidden; // BOOL

extern NSString* UISwitchOn; // BOOL
extern NSString* UISwitchEnabled; // BOOL
extern NSString* UISwitchHidden; // BOOL

extern NSString* UITextFieldText; // NSString
extern NSString* UITextFieldAttributedText; // NSAttributedString
extern NSString* UITextFieldEnabled; // BOOL
extern NSString* UITextFieldHidden; // BOOL

extern NSString* UITextViewText; // NSString
extern NSString* UITextViewAttributedText; // NSAttributedString
extern NSString* UITextViewEditable; // BOOL
extern NSString* UITextViewHidden; // BOOL
NS_ASSUME_NONNULL_END

#include "BindKitVendor.h"

#endif // BindKit_h
