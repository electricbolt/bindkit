/*******************************************************************************
 * BindKitVendor.h                                                             *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#ifndef BindKitVendor_h
#define BindKitVendor_h

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

#endif // BindKitVendor_h
