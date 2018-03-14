/*******************************************************************************
 * EBKProperty.m                                                               *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"
#import "EBKProperty.h"

@interface EBKProperty () {
    objc_property_t property;
    NSArray* attributes;
}

@end

@implementation EBKProperty

- (instancetype) initWithObjCProperty: (objc_property_t) _property {
    self = [super init];
    if (self) {
        property = _property;
        attributes = [[NSString stringWithUTF8String: property_getAttributes(_property)] componentsSeparatedByString: @","];
    }
    return self;
}

- (NSString* _Nonnull) name {
    return [NSString stringWithUTF8String: property_getName(property)];
}

- (BOOL) hasAttribute: (NSString* _Nonnull) code {
    for (NSString* encoded in attributes)
        if ([encoded hasPrefix: code])
            return YES;
    return NO;
}

- (BOOL) isReadOnly {
    // R = read-only
    return [self hasAttribute: @"R"];
}

- (NSString* _Nullable) contentOfAttribute: (NSString*) code {
    for (NSString* encoded in attributes)
        if ([encoded hasPrefix: code])
            return [encoded substringFromIndex: 1];
    return nil;
}

- (SEL _Nonnull) getter {
    // G = custom setter name
    SEL sel = NSSelectorFromString([self contentOfAttribute: @"G"]);
    if (sel != nil)
        return sel;
    NSString* s = [NSString stringWithUTF8String: property_getName(property)];
    return NSSelectorFromString(s);
}

- (SEL _Nullable) setter {
    if ([self isReadOnly])
        return nil;
    // S = custom setter name
    SEL sel = NSSelectorFromString([self contentOfAttribute: @"S"]);
    if (sel != nil)
        return sel;
    // Uppercase first character of property name, prepend set, append :
    // e.g. onOff -> setOnOff:
    NSString* s = [NSString stringWithUTF8String: property_getName(property)];
    s = [NSString stringWithFormat: @"set%@:", [EBKProperty firstLetterCapitalized: s]];
    return NSSelectorFromString(s);
}

- (NSString*) encodedType {
    return  [self contentOfAttribute: @"T"];
}

- (NSString*) description {
    SEL setter = [self setter];
    NSString* setterStr = @"nil";
    if (setter != nil)
        setterStr = NSStringFromSelector(setter);
    NSString* getterStr = NSStringFromSelector([self getter]);
    return [NSString stringWithFormat: @"EBKProperty {name = %@, getter = %@, setter = %@}", [self name], getterStr, setterStr];
}

+ (NSString*) firstLetterCapitalized: (NSString*) string {
    if ([string length] == 0)
        return string;
    NSMutableString* sb = [[NSMutableString alloc] initWithString: string];
    [sb replaceCharactersInRange: NSMakeRange(0, 1) withString: [string substringToIndex: 1].uppercaseString];
    return sb;
}

+ (EBKProperty* _Nullable) object: (NSObject*) object property: (NSString*) propertyName {
    // Recursively search the current class, then it's superclass.
    Class clazz = [object class];
    while (clazz != nil && clazz != [NSObject class]) {
        EBKVERBOSE(@"Property with name %@ for class %@", propertyName, NSStringFromClass(clazz));
        unsigned int propertyCount = 0;
        objc_property_t* propertyList = class_copyPropertyList(clazz, &propertyCount);
        for (int i = 0; i < propertyCount; i++) {
            EBKProperty* property = [[EBKProperty alloc] initWithObjCProperty: propertyList[i]];
            EBKVERBOSE(@"[%ld] %@", (long) i, property);
            if ([property.name isEqualToString: propertyName]) {
                free(propertyList);
                return property;
            }
        }
        free(propertyList);
        clazz = [clazz superclass];
    }
    return nil;
}

+ (NSString*) object: (NSObject*) object propertyTypeEncoding: (NSString*) name {
    EBKProperty* v = [EBKProperty object: object property: name];
    NSString* encodedType = nil;
    if ([v.encodedType length] > 0)
        encodedType = v.encodedType;
    if (encodedType == nil) {
        // Not a property. Check method definitions.
        Method m = class_getInstanceMethod(object.class, NSSelectorFromString(name));
        if (m == nil) {
            NSString* isViewProperty = [NSString stringWithFormat: @"is%@", [EBKProperty firstLetterCapitalized: name]];
            m = class_getInstanceMethod(object.class, NSSelectorFromString(isViewProperty));
            if (m == nil)
                return nil;
        }
        char returnType[256];
        method_getReturnType(m, returnType, sizeof(returnType));
        encodedType = [NSString stringWithCString: returnType encoding: NSASCIIStringEncoding];
    }
    encodedType = [EBKProperty unencodedPropertyType: encodedType];
    return encodedType;
}

+ (NSString*) unencodedPropertyType: (NSString*) encoded {
    if ([encoded length] > 1) {
        // Convert "{NSString=#}" into "NSString".
        NSMutableString* sb = [NSMutableString new];
        for (int i = 0; i < [encoded length]; i++) {
            char c = [encoded characterAtIndex: i];
            if (isalpha(c))
                [sb appendFormat: @"%c", c];
        }
        return sb;
    }
    return encoded;
}

@end
