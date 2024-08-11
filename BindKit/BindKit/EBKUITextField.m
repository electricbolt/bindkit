// EBKUITextField.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"
#import <objc/runtime.h>

NSString* UITextFieldText = @"text";
NSString* UITextFieldAttributedText = @"attributedText";
NSString* UITextFieldEnabled = @"enabled";
NSString* UITextFieldHidden = @"hidden";

@interface EBKUITextField : UITextField

@end

@implementation EBKUITextField

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UITextFieldTextDidChangeNotification object: self];
}

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UITextFieldText: EBKTypeEncode(NSString), UITextFieldAttributedText: EBKTypeEncode(NSAttributedString), UITextFieldEnabled: EBKTypeEncode(BOOL), UITextFieldHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(textChanged:) name: UITextFieldTextDidChangeNotification object: self];
}

- (void) textChanged: (NSNotification*) notification {
    NSObject* v = [self boundValueForViewKey: UITextFieldText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (self.text != nil)
            [self setBoundValue: self.text viewKey: UITextFieldText];
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![self.text isEqualToString: (NSString*) v])
            [self setBoundValue: self.text viewKey: UITextFieldText];
    }

    v = [self boundValueForViewKey: UITextFieldAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (self.attributedText != nil)
            [self setBoundValue: self.attributedText viewKey: UITextFieldAttributedText];
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![self.attributedText isEqualToAttributedString: (NSAttributedString*) v])
            [self setBoundValue: self.attributedText viewKey: UITextFieldAttributedText];
    }
}

- (void) setText: (NSString*) text {
    if (![self.text isEqualToString: text])
        [super setText: text];
    NSObject* v = [self boundValueForViewKey: UITextFieldText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (text != nil)
            [self setBoundValue: nil viewKey: UITextFieldText];
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![text isEqualToString: (NSString*) v])
            [self setBoundValue: text viewKey: UITextFieldText];
    }
}

- (void) setAttributedText: (NSAttributedString*) attributedText {
    if (![self.attributedText isEqualToAttributedString: attributedText])
        [super setAttributedText: attributedText];
    NSObject* v = [self boundValueForViewKey: UITextFieldAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (attributedText != nil)
            [self setBoundValue: nil viewKey: UITextFieldAttributedText];
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![attributedText isEqualToAttributedString: (NSAttributedString*) v])
            [self setBoundValue: attributedText viewKey: UITextFieldAttributedText];
    }
}

- (void) setEnabled: (BOOL) enabled {
    if (super.enabled != enabled)
        [super setEnabled: enabled];
    NSObject* v = [self boundValueForViewKey: UITextFieldEnabled];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != enabled)
            [self setBoundValue: [NSNumber numberWithBool: enabled] viewKey: UITextFieldEnabled];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UITextFieldHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UITextFieldHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UITextFieldText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.text != nil)
            super.text = nil;
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![super.text isEqualToString: (NSString*) v])
            super.text = (NSString*) v;
    }

    v = [self boundValueForViewKey: UITextFieldAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.attributedText != nil)
            super.attributedText = nil;
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![super.attributedText isEqualToAttributedString: (NSAttributedString*) v])
            super.attributedText = (NSAttributedString*) v;
    }

    v = [self boundValueForViewKey: UITextFieldEnabled];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.enabled != [((NSNumber*) v) boolValue])
            super.enabled = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UITextFieldHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UITextField (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUITextField.class;
}

@end
