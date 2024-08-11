// EBKUILabel.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "BindKit.h"

NSString* UILabelText = @"text";
NSString* UILabelAttributedText = @"attributedText";
NSString* UILabelHidden = @"hidden";

@interface EBKUILabel : UILabel

@end

@implementation EBKUILabel

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UILabelText: EBKTypeEncode(NSString), UILabelAttributedText: EBKTypeEncode(NSAttributedString), UILabelHidden: EBKTypeEncode(BOOL)};
}

- (void) setText: (NSString*) text {
    if (![self.text isEqualToString: text])
        [super setText: text];
    NSObject* v = [self boundValueForViewKey: UILabelText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (text != nil)
            [self setBoundValue: nil viewKey: UILabelText];
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![text isEqualToString: (NSString*) v])
            [self setBoundValue: text viewKey: UILabelText];
    }
}

- (void) setAttributedText: (NSAttributedString*) attributedText {
    if (![self.attributedText isEqualToAttributedString: attributedText])
        [super setAttributedText: attributedText];
    NSObject* v = [self boundValueForViewKey: UILabelAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (attributedText != nil)
            [self setBoundValue: nil viewKey: UILabelAttributedText];
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![attributedText isEqualToAttributedString: (NSAttributedString*) v])
            [self setBoundValue: attributedText viewKey: UILabelAttributedText];
    }
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UILabelHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UILabelHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UILabelText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.text != nil)
            super.text = nil;
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![super.text isEqualToString: (NSString*) v])
            super.text = (NSString*) v;
    }

    v = [self boundValueForViewKey: UILabelAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.attributedText != nil)
            super.attributedText = nil;
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![super.attributedText isEqualToAttributedString: (NSAttributedString*) v])
            super.attributedText = (NSAttributedString*) v;
    }

    v = [self boundValueForViewKey: UILabelHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UILabel (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUILabel.class;
}

@end
