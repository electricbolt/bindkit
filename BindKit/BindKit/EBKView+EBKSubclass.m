// EBKView+EBKSubclass.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"
#import "EBKView+EBKSubclass.h"
#import "NSObject+EBKBinding.h"
#import <objc/runtime.h>

@implementation EBKView (EBKSubclass)

+ (BOOL) EBKSubclassInstance: (EBKView*) view {
    // Step 1. ensure that we haven't already dynamically subclassed 'view'.
    Class viewClass = object_getClass(view);
    if (class_getInstanceMethod(viewClass, @selector(EBKClass)) != NULL)
        return NO;

    // Step 2. create the new combined class name in format "EBKUISwitch_UISwitch"
    const char* combinedClassName = [[NSString stringWithFormat:@"%s_%s", class_getName(self), class_getName(viewClass)] UTF8String];

    // Step 3. check to see if the combined class has already been registered
    // into the ObjC class list
    Class combinedClass = objc_getClass(combinedClassName);
    if (combinedClass == nil) {
        // Step 4. combined class does not yet exist - create it
        combinedClass = objc_allocateClassPair(viewClass, combinedClassName, 0);
        
        // Step 5. copy all methods from the EBKUI* class to combined class
        unsigned int methodCount = 0;
        Method* methodList = class_copyMethodList(self, &methodCount);
        for (unsigned int i = 0; i < methodCount; i++) {
            Method method = methodList[i];
            class_addMethod(combinedClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
        }
        free(methodList);

        // Step 6. Override the "class" method to return the original class (e.g. UISwitch).
        Method classMethod = class_getInstanceMethod(viewClass, @selector(class));
        IMP methodIMP = imp_implementationWithBlock(^(id _self, SEL _sel) {
            return class_getSuperclass(object_getClass(_self));
        });
        class_addMethod(combinedClass, method_getName(classMethod), methodIMP, method_getTypeEncoding(classMethod));

        // Step 7. add method EBKClass as declared in EBKView+EBKClass, so we
        // can detect if we're already dynamically subclassed (Step 1). Because
        // encodings returned from method_getTypeEncoding are undocumented, we
        // use a method (EBKClass) that is identical to one already existing
        // (class).
        methodIMP = imp_implementationWithBlock(^(id _self, SEL _sel) {
            return viewClass;
        });
        class_addMethod(combinedClass, @selector(EBKClass), methodIMP, method_getTypeEncoding(classMethod));

        // Step 8. Register the combined class into the ObjC class list.
        objc_registerClassPair(combinedClass);

        // Step 9. Confirm that the original class and the combined class are the same
        if (class_getInstanceSize(viewClass) != class_getInstanceSize(combinedClass))
            @throw [NSException exceptionWithName: EBKBindingException reason:
                [NSString stringWithFormat: @"Class %s couldn't be subclassed", class_getName(viewClass)] userInfo: nil];
    }

    // Step 10. Change the class of the view to the combined class.
    object_setClass(view, combinedClass);
    return YES;
}

@end
