//
//  NSMutableString.swift
//  NOVID-19
//
//  Created by Mark Calvo-Cruz on 5/10/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//
//reference: https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift

import UIKit
extension NSMutableAttributedString {
    var fontSize: CGFloat { return 14 }
var boldFont: UIFont { return UIFont(name: "Product Sans Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
var normalFont: UIFont { return UIFont(name: "Product Sans Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

func bold(_ value:String) -> NSMutableAttributedString {

    let attributes:[NSAttributedString.Key : Any] = [
        .font : boldFont
    ]

    self.append(NSAttributedString(string: value, attributes:attributes))
    return self
}

func normal(_ value:String) -> NSMutableAttributedString {

    let attributes:[NSAttributedString.Key : Any] = [
        .font : normalFont,
    ]

    self.append(NSAttributedString(string: value, attributes:attributes))
    return self
}
}
