/*******************************************************************************
 * Colorize.swift                                                              *
 * BindingExample - BindKit Copyright (c) 2018; Electric Bolt Limited.         *
 ******************************************************************************/

import Foundation

func colorize(_ s : String) -> NSAttributedString {
    let s = NSMutableAttributedString(string: s)
    for i in 0 ..< s.length {
        s.setAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)],
             range: NSMakeRange(i, 1))
    }
    return s
}
