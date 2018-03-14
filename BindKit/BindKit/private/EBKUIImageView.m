/*******************************************************************************
 * EBKUIImageView.m                                                            *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "BindKit.h"

NSString* UIImageViewImage = @"image";
NSString* UIImageViewHidden = @"hidden";

@interface EBKUIImageView : UIImageView

@end

@implementation EBKUIImageView

- (NSDictionary<NSString*, NSString*>*) bindableProperties {
    return @{UIImageViewImage: EBKTypeEncode(UIImage), UIImageViewHidden: EBKTypeEncode(BOOL)};
}

- (void) setImage: (UIImage*) image {
    // Always pass through without checking super.image, as UIImage doesn't
    // have a notion of equality.
    [super setImage: image];
    NSObject* v = [self boundValueForViewKey: UIImageViewImage];
    if ([v isKindOfClass: [NSNull class]]) {
        if (image != nil)
            [self setBoundValue: nil viewKey: UIImageViewImage];
    } else if ([v isKindOfClass: [UIImage class]]) {
        [self setBoundValue: image viewKey: UIImageViewImage];
    }
}

- (void) setHidden: (BOOL) hidden {
    if (super.hidden != hidden)
        [super setHidden: hidden];
    NSObject* v = [self boundValueForViewKey: UIImageViewHidden];
    if ([v isKindOfClass: [NSNumber class]])
        if ([((NSNumber*) v) boolValue] != hidden)
            [self setBoundValue: [NSNumber numberWithBool: hidden] viewKey: UIImageViewHidden];
}

- (void) updateViewFromBoundModel {
    NSObject* v = [self boundValueForViewKey: UIImageViewImage];
    if ([v isKindOfClass: [NSNull class]]) {
        if (super.image != nil)
            super.image = nil;
    } else if ([v isKindOfClass: [UIImage class]]) {
        super.image = (UIImage*) v;
    }

    v = [self boundValueForViewKey: UIImageViewHidden];
    if ([v isKindOfClass: [NSNumber class]]) {
        if (super.hidden != [((NSNumber*) v) boolValue])
            super.hidden = [((NSNumber*) v) boolValue];
    }
}

@end

@implementation UIImageView (EBKDynamicSubclassRegistry)

- (Class) EBKDynamicSubclass {
    return EBKUIImageView.class;
}

@end
