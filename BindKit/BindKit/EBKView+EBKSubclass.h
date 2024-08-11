// EBKView+EBKSubclass.h
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

@import Foundation;

@interface EBKView (EBKClass)

/**
 @brief Marker property that we can check within EBKSubclassInstance to see if
 we've already been dynamically subclassed.
 @return Returns the original class. (e.g. if this is EBKUISwitch_UISwitch, then
 returns UISwitch.class)
 */
@property (readonly, nullable) Class EBKClass;

@end

@interface EBKView (EBKSubclass)

/**
 @brief Dynamically subclasses a view at runtime.
 @return YES if dynamically subclassed, or NO if the view was already subclassed.
 @throws EBKBindingException if any error occured whilst trying to subclass.

 @param view is an instance of a view that we want to subclass (e.g. UISwitch)

 @remark 'self' here is EBKUI* class (e.g. EBKUISwitch.class)
 */
+ (BOOL) EBKSubclassInstance: (EBKView* _Nonnull) view;

@end
