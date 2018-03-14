/*******************************************************************************
 * EBKBinding.h                                                                *
 * BindKit Copyright (c) 2018; Electric Bolt Limited.                          *
 ******************************************************************************/

#import "EBKProperty.h"

@interface EBKBinding : NSObject

@property(strong, nonnull) NSObject* model;
@property(strong, nonnull) EBKProperty* modelProperty;
@property(strong, nonnull) EBKView* view;
@property(strong, nonnull) NSString* viewProperty;
@end
