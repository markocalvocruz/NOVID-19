//
//  Product.swift
//  COVID19
//
//  Created by Mark Calvo-Cruz on 3/13/20.
//  Copyright © 2020 Mark Calvo-Cruz. All rights reserved.
//

import Foundation



struct Product: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case feed = "feed"
        case entry = "entry"

        case name = "gsx$commerciallyavailableproductname\\"
        case distributor = "gsx$companydistributor\\"
        case epa_reg = "gsx$eparegnumber\\"
        case updated = "updated\\"
        
        case value = "$t\\"
    }
    

    init(from decoder: Decoder) throws {
        let entry = try decoder.container(keyedBy: CodingKeys.self)

        let updated_container = try entry.nestedContainer(keyedBy: CodingKeys.self, forKey: .updated)
        updated = try updated_container.decode(Date.self, forKey: .value)
        
        let name_container = try entry.nestedContainer(keyedBy: CodingKeys.self, forKey: .name)
        name = try name_container.decode(String.self, forKey: .value)
        
        let distributor_container = try entry.nestedContainer(keyedBy: CodingKeys.self, forKey: .distributor)
        distributor = try distributor_container.decode(String.self, forKey: .value)
        
        let epareg_container = try entry.nestedContainer(keyedBy: CodingKeys.self, forKey: .epa_reg)
        epa_reg = try epareg_container.decode(String.self, forKey: .value)

        
    }
    var updated: Date
    var name: String
    var distributor: String
    var epa_reg: String
}
