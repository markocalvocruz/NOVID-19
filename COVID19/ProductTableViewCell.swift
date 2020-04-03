//
//  ProductTableViewCell.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/15/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    var product: Entry! {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var status_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateUI() {
        if let name = product.name?.t {
            self.name_label.text = name

        }
        self.status_label.text = "APPROVED"
        self.name_label.font = UIFont.systemFont(ofSize: 20.0)

        self.status_label.font = UIFont.systemFont(ofSize: 15.0)
        self.status_label.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        
    }
}
