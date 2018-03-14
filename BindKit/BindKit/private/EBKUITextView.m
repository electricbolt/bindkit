/*******************************************************************************
 * EBKUITextView.m                                                             *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"

NSString* UITextViewText = @"text";
NSString* UITextViewAttributedText = @"attributedText";
NSString* UITextViewEditable = @"editable";
NSString* UITextViewHidden = @"hidden";

@interface EBKUITextView : UITextView

@end

@implementation EBKUITextView

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UITextViewTextDidChangeNotification object: self];
}

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UITextViewText: EBKTypeEncode(NSString), UITextViewAttributedText: EBKTypeEncode(NSAttributedString), UITextViewEditable: EBKTypeEncode(BOOL), UITextViewHidden: EBKTypeEncode(BOOL)};
}

- (void) viewDidBindWithModel {
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object: self];
}

- (void) textChanged: (NSNotification*) notification {
    NSObject* v = [self boundValueForViewKey: UITextViewText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (self.text != nil)
            [self setBoundValue: self.text viewKey: UITextViewText];
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![self.text isEqualToString: (NSString*) v])
            [self setBoundValue: self.text viewKey: UITextViewText];
    }

    v = [self boundValueForViewKey: UITextViewAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (self.attributedText != nil)
            [self setBoundValue: self.attributedText viewKey: UITextViewAttributedText];
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![self.attributedText isEqualToAttributedString: (NSAttributedString*) v])
            [self setBoundValue: self.attributedText viewKey: UITextViewAttributedText];
    }
}

- (void) setText: (NSString*) text {
    if (![self.text isEqualToString: text])
        [super setText: text];
    NSObject* v = [self boundValueForViewKey: UITextViewText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (text != nil)
            [self setBoundValue: nil viewKey: UITextViewText];
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![text isEqualToString: (NSString*) v])
            [self setBoundValue: text viewKey: UITextViewText];
    }
}

- (void) setAttributedText: (NSAttributedString*) attributedText {
    if (![self.attributedText isEqualToAttributedString: attributedText])
        [super setAttributedText: attributedText];
    NSObject* v = [self boundValueForViewKey: UITextViewAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (attributedText != nil)
            [self setBoundValue: nil viewKey: UITextViewAttributedText];
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![attributedText isEqualToAttributedString: (NSAttributedString*) v])
            [self setBoundValue: attributedText viewKey: UITextViewAttributedText];
    }
}

- (void) setEditable: (BOOL) editable {
    if (super.editable != editable)
        [super setEditable: editable];
    NSObject* v = [self boundValueForViewKey: UITextViewEditable];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != editable)
            [self setBoundValue: [NSNumber numberWithBool: editable] viewKey: UITextViewEditable];
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UITextViewHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UITextViewHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UITextViewText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.text != nil)
            super.text = nil;
    } else if ([v isKindOfClass: [NSString class]]) {
        if (![super.text isEqualToString: (NSString*) v])
            super.text = (NSString*) v;
    }

    v = [self boundValueForViewKey: UITextViewAttributedText];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.attributedText != nil)
            super.attributedText = nil;
    } else if ([v isKindOfClass: [NSAttributedString class]]) {
        if (![super.attributedText isEqualToAttributedString: (NSAttributedString*) v])
            super.attributedText = (NSAttributedString*) v;
    }

    v = [self boundValueForViewKey: UITextViewEditable];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.editable != [((NSNumber*) v) boolValue])
            super.editable = [((NSNumber*) v) boolValue];
    }

    v = [self boundValueForViewKey: UITextViewHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UITextView (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUITextView.class;
}

@end
