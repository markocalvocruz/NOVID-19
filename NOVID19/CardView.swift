//
//  CardVIew.swift
//  NOVID-19
//
//  Created by Mark Calvo-Cruz on 5/10/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit

extension CGFloat {
    static let cardView_btn_width: CGFloat = 150
    static let cardView_btn_height: CGFloat = 52

}

class CardView: UIView {
    
    var messageLabel: UILabel!
    var shareButton: UIButton!
    var scanButton: UIButton!
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageLabel)
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle("Share", for: .normal)
        shareButton.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.7568627451, blue: 0.007843137255, alpha: 1)
        
        scanButton = UIButton()
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.setTitle("Scan Item", for: .normal)
        scanButton.backgroundColor = #colorLiteral(red: 0, green: 0.651288271, blue: 1, alpha: 1)
        
        stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8.0
        stackView.addSubview(scanButton)
        stackView.addSubview(shareButton)
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 32.0),
            messageLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 50.0),
            messageLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 50.0),
            messageLabel.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: 36.0),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: 32.0),
             
             scanButton.widthAnchor.constraint(equalToConstant: .cardView_btn_width),
             scanButton.heightAnchor.constraint(equalToConstant: .cardView_btn_height),
             shareButton.widthAnchor.constraint(equalToConstant: .cardView_btn_width),
             shareButton.heightAnchor.constraint(equalToConstant: .cardView_btn_height)
   
 
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
