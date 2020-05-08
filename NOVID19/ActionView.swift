//
//  ActionView.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 5/7/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit

extension CGFloat {
    static let btn_width: CGFloat = 150.0
    static let btn_height: CGFloat = 52.0

}
class ActionView: UIView {

    var share_button: UIButton!
    var scan_button: UIButton!
    var msg_label: UILabel!
    
    func loadView() {
        share_button = UIButton(type: .roundedRect)
        share_button.translatesAutoresizingMaskIntoConstraints = false
        share_button.layer.cornerRadius = 25

        scan_button = UIButton(type: .roundedRect)
        scan_button.layer.cornerRadius = 25
        
        scan_button.translatesAutoresizingMaskIntoConstraints = false
        
        msg_label = UILabel()
        msg_label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scan_button.widthAnchor.constraint(equalToConstant: CGFloat.btn_width),
            scan_button.widthAnchor.constraint(equalToConstant: CGFloat.btn_width)

        ])
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
