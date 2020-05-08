//
//  DataManager.swift
//  NOVID19
//
//  Created by Mark Calvo-Cruz on 3/20/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import Foundation

class DataManager {
    //static var products: [Product] = []
    static var products: [Entry]  = []
    static var product_names : [String] { return products.compactMap { $0.name?.t}}
    static func searchProductsForString(_ str: String) -> Entry? {
        //print("searching for \(str)")
        if str.isEmpty { return nil }
        for (index,product) in DataManager.product_names.enumerated() {
            if str.range(of: product, options: .caseInsensitive) != nil {
                return DataManager.products[index]
            }
            
        }
        return nil
    }
}
