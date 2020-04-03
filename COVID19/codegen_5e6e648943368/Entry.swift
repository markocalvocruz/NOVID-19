/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Entry : Decodable {
	let id : Id?
	let updated : Updated?
	let title : Title?
	let content : Content?
	//let link : [Link]?
	let name : Name?
	let distributor : Distributor?
	let epaNumber : EPANumber?
    let category: Category?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case updated = "updated"
		case title = "title"
		case content = "content"
		case link = "link"
		case name = "gsx$commerciallyavailableproductname"
		case distributor = "gsx$companydistributor"
		case epaNumber = "gsx$eparegnumber"
        case category = "gsx$dilutable"
	}
    

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Id.self, forKey: .id)
		updated = try values.decodeIfPresent(Updated.self, forKey: .updated)
		title = try values.decodeIfPresent(Title.self, forKey: .title)
        content = try values.decodeIfPresent(Content.self, forKey: .content)
      //  link = try values.decodeIfPresent([Link].self, forKey: .link)
    //  category = try values.decodeIfPresent([Category].self, forKey: .category)
    //  let nameContainer = try values.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
    //  name = try nameContainer.decodeIfPresent(Entry.Name.self, forKey: .t)
        name = try values.decodeIfPresent(Entry.Name.self, forKey: .name)

		distributor = try values.decodeIfPresent(Distributor.self, forKey: .distributor)
		epaNumber = try values.decodeIfPresent(EPANumber.self, forKey: .epaNumber)
        category = try values.decodeIfPresent(Category.self, forKey: .category)

	}

    struct Name : Codable {
        let t : String?

        enum CodingKeys: String, CodingKey {
            case t = "$t"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            t = try values.decodeIfPresent(String.self, forKey: .t)
        }
    }
    
    struct EPANumber : Codable {
        let t : String?

        enum CodingKeys: String, CodingKey {
            case t = "$t"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            t = try values.decodeIfPresent(String.self, forKey: .t)
        }
    }
    
    struct Distributor : Codable {
        let t : String?

        enum CodingKeys: String, CodingKey {
            case t = "$t"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            t = try values.decodeIfPresent(String.self, forKey: .t)
        }

    }

    struct Category : Codable {
        let t : String?

        enum CodingKeys: String, CodingKey {
            case t = "$t"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            t = try values.decodeIfPresent(String.self, forKey: .t)
        }

    }

}
