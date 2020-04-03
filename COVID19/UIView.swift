//
//  UIView.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/25/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit
extension UIView {
    func hide() {
        self.alpha = 0.0
    }
    func show() {
        self.alpha = 1.0
    }
    
}

extension Bool {
    mutating func toggle() {
        if self == true {
            self = false
        } else {
            self = true
        }
    }
}
