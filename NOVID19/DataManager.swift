//
//  DataManager.swift
//  NOVID19
//
//  Created by Mark Calvo-Cruz on 3/20/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import Foundation

class DataManager {

    static var products : [String] = []
    static func searchProductsForString(_ str: String) -> String? {
        if str.isEmpty { return nil }
        for (index,product) in DataManager.products.enumerated() {
            if str.range(of: product, options: .caseInsensitive) != nil {
                return DataManager.products[index]
            }
            
        }
        return nil
    }
}
