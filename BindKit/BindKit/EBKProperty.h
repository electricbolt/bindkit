// EBKProperty.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"
#import <objc/runtime.h>

/**
 Wraps objc_property_t
 */
@interface EBKProperty : NSObject

- (id _Nonnull) initWithObjCProperty: (objc_property_t _Nonnull) property;

/**
 Returns YES if the property is read only.
 */
- (BOOL) isReadOnly;

/**
 * Returns the property getter selector.
 */
- (SEL _Nonnull) getter;

/**
 * Returns the property setter selector. If the property is read only, then nil
 * is returned.
 */
- (SEL _Nullable) setter;

/**
 Returns the name of the property.
 */
- (NSString* _Nonnull) name;

/**
 Returns the type of the property. Valid property types are those specified in "Objective-C type encodings"
 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 c = char
 i = int
 s = short
 l = long l is treated as a 32-bit quantity on 64-bit programs.
 q = long long
 C = unsigned char
 I = unsigned int
 S = unsigned short
 L = unsigned long
 Q = unsigned long long
 f = float
 d = double
 B = BOOL
 @"object" = Where `object` is NSString, NSAttributedString etc
 */
- (NSString* _Nonnull) encodedType;

/**
 Returns an EBKProperty (wrapping an objc_property_t) of a property on an object that has
 the name specified. Returns nil if the property doesn't exist.
 */
+ (EBKProperty* _Nullable) object: (NSObject* _Nonnull) object property: (NSString* _Nonnull) propertyName;

/**
 Some view properties aren't actually implemented as properties at all. For instance
 "UIControl.enabled". We therefore have to check for method getter and its return value.
 The return value is an Objective-C type encoding. e.g. "B" or "NSString". If the
 property is not found, then nil is returned.
 */
+ (NSString* _Nullable) object: (NSObject* _Nonnull) object propertyTypeEncoding: (NSString* _Nonnull) name;

/**
 If the property type encoding is an object, then returns just object.
 If the property type encoding is not an object (e.g. a simple type), then returns the simple type as is.
 "{NSString=#}" -> "NSString"
 "B" -> "B"
 */
+ (NSString* _Nonnull) unencodedPropertyType: (NSString* _Nonnull) encoded;

@end
