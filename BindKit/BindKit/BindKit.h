// BindKit.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#ifndef BindKit_h
#define BindKit_h

#import <UIKit/UIKit.h>

// Not all UIKit views inherit from UIView (e.g. UIBarButtonItem).
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
extern NSString* UIDatePickerEnabled; // BOOL - available on OS10+
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

/**
 @brief Returns the version of the BindKit library.
 */
extern NSString* _Nonnull EBKVersion(void);

#pragma mark Vendor integration APIs - dynamic subclassing of views

/**
 @brief The name of the NSException that is thrown when a programmer error
 is detected during binding.
 @remark See also bindSel:toView:viewSel: for details of exceptions
 */
extern NSString* _Nonnull EBKBindingException;

/*
 @brief This macro can be used in an overidden bindableProperties to return an
 property type string of the property type v.
 @code
 return @{UISwitchEnabled: EBKTypeEncode(BOOL)}; // "enabled"="B"
 @endCode
 */
#define EBKTypeEncode(v) [NSString stringWithCString: @encode(v) encoding: NSASCIIStringEncoding]

@interface EBKView (EBKDynamicSubclass)

/**
 @brief Override this method to return a dictionary of valid property names and
 types.
 @discussion Valid property types are those specified in "Objective-C type encodings"
 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 */
- (NSDictionary<NSString*,NSString*>* _Nonnull) bindableProperties;

/**
 @brief This method will be called when the view has been bound with the model's
 first property only.
 @discussion Override this method if your view needs to subscribe to
 notifications or control events to listen for changes input by the user.
 See EBKUI* classes for more details.
 */
- (void) viewDidBindWithModel;

/**
 @brief This method is called when the bound object's properties have been updated,
 and the view's properties need to be updated to keep in sync.
 @discussion See EBKUI* classes for more details.
 */
- (void) updateViewFromBoundModel;

/**
 @brief If the view property is bound to an model property, then the value is
 set onto the model against the bound model property.
 */
- (void) setBoundValue: (NSObject* _Nullable) value viewKey: (NSString* _Nonnull) viewKey;

/**
 @brief If the view property is mapped to an model property, then the value is
 retrieved from the model against the mapped model property.
 @discussion If the value is non-nil then the value is returned. If the value is
 nil, the [NSNull null] is returned. If the view property is not mapped to an
 object property, then nil is returned.
 */
- (NSObject* _Nullable) boundValueForViewKey: (NSString* _Nonnull) viewKey NS_SWIFT_NAME(boundValue(viewKey:));

@end

@interface EBKView (EBKDynamicSubclassRegistry)

/**
 @brief Override to return the EBKUI* version of a UIKit view.
 */
- (Class _Nullable) EBKDynamicSubclass NS_SWIFT_NAME(EBKDynamicSubclass());

@end

#pragma mark Vendor integration - debug logging

typedef NS_OPTIONS(NSUInteger, EBKLogFlag) {
    EBKLogFlagError = 1 << 0,    // 0...00001
    EBKLogFlagWarn = 1 << 1,     // 0...00010
    EBKLogFlagInfo = 1 << 2,     // 0...00100
    EBKLogFlagDebug = 1 << 3,    // 0...01000
    EBKLogFlagVerbose = 1 << 4,  // 0...10000
};

typedef NS_ENUM(NSUInteger, EBKLogLevel) {
    EBKLogLevelOff = 0,                                           // 0...00000
    EBKLogLevelError = (EBKLogFlagError),                         // 0...00001
    EBKLogLevelWarn = (EBKLogLevelError|EBKLogFlagWarn),          // 0...00011
    EBKLogLevelInfo = (EBKLogLevelWarn|EBKLogFlagInfo),           // 0...00111
    EBKLogLevelDebug = (EBKLogLevelInfo|EBKLogFlagDebug),         // 0...01111
    EBKLogLevelVerbose = (EBKLogLevelDebug|EBKLogFlagVerbose),    // 0...11111
    EBKLogLevelAll = NSUIntegerMax                                // 1111...1111
};

#define EBKERROR(msg,...) EBKLogO(EBKLogFlagError,__FILE__,NSStringFromSelector(_cmd),__LINE__,msg,##__VA_ARGS__)
#define EBKDEBUG(msg,...) EBKLogO(EBKLogFlagDebug,__FILE__,NSStringFromSelector(_cmd),__LINE__,msg,##__VA_ARGS__)
#define EBKVERBOSE(msg,...) EBKLogO(EBKLogFlagVerbose,__FILE__,NSStringFromSelector(_cmd),__LINE__,msg,##__VA_ARGS__)

/**
 @brief Enables or disables logging to the console based upon the level specified.
 @discussion Valid logging levels are EBKLogLevelOff < EBKLogLevelError < EBKLogLevelWarn < EBKLogLevelInfo < EBKLogLevelDebug < EBKLogLevelVerbose.
 The default logging level is EBKLogLevelError.
 */
extern void EBKSetLogging(EBKLogLevel logLevel);

/**
 @brief Logs an ObjC style string and variable arguments in sprintf format to the
 console if logging is enabled.
 */
extern void EBKLogO(EBKLogFlag logFlag, const char* _Nonnull path, NSString* _Nonnull method, int line, NSString* _Nonnull msg, ...);

/**
 @brief Logs an Swift style string to the console if logging is enabled.
 */
extern void EBKLogS(EBKLogFlag logFlag, NSString* _Nonnull msg);

#pragma mark Vendor integration - multicasting delegates for dynamic subclasses

/**
 @brief Multi-casting delegate
 @discussion If a dynamic subclass needs to use delegation to be notified of changes
 to the view (as opposed to target-action or notifications), then it can
 use this class to multi-cast delegate methods.
 @remark See MySearchBar.swift for usage.
 */
@interface EBKMulticastDelegate : NSObject

@property(weak, nullable) id primaryDelegate;
@property(weak, nullable) id secondaryDelegate;

@end

#endif // BindKit_h
