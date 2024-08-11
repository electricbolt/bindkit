// EBKBinding.m
// BindKit Copyright (c) 2018-2024; Electric Bolt Limited.

#import "EBKBinding.h"

@implementation EBKBinding

- (NSString*) debugDescription {
    return [NSString stringWithFormat: @"EBKBinding {model = %@, modelProperty = %@, view = %@, viewProperty = %@}",
        _model == nil ? @"nil" : _model.debugDescription, [_modelProperty debugDescription],
        _view == nil ? @"nil" : _view.debugDescription, _viewProperty];
}

- (BOOL) isEqual: (id) other {
    if (other == nil)
        return NO;
    if (![other isKindOfClass: [EBKBinding class]])
        return NO;
    EBKBinding* otherBinding = (EBKBinding*) other;
    if (![_model isEqual: otherBinding->_model])
        return NO;
    if (![_modelProperty.name isEqualToString: otherBinding->_modelProperty.name])
        return NO;
    if (![_view isEqual: otherBinding->_view])
        return NO;
    return [_viewProperty isEqualToString: otherBinding->_viewProperty];
}

@end
