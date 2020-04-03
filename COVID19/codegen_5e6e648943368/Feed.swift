/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Feed : Decodable {
	let xmlns : String?
	let xmlns$openSearch : String?
	let xmlns$gsx : String?
	let id : Id?
	let updated : Updated?
    // let category : [Category]?
	let title : Title?
//	let link : [Link]?
//	let author : [Author]?
	let openSearch$totalResults : OpenSearch$totalResults?
	let openSearch$startIndex : OpenSearch$startIndex?
	let entry : [Entry]?

	enum CodingKeys: String, CodingKey {

		case xmlns = "xmlns"
		case xmlns$openSearch = "xmlns$openSearch"
		case xmlns$gsx = "xmlns$gsx"
		case id = "id"
		case updated = "updated"
        //case category = "category"
		case title = "title"
		//case link = "link"
	//	case author = "author"
		case openSearch$totalResults = "openSearch$totalResults"
		case openSearch$startIndex = "openSearch$startIndex"
		case entry = "entry"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		xmlns = try values.decodeIfPresent(String.self, forKey: .xmlns)
		xmlns$openSearch = try values.decodeIfPresent(String.self, forKey: .xmlns$openSearch)
		xmlns$gsx = try values.decodeIfPresent(String.self, forKey: .xmlns$gsx)
		id = try values.decodeIfPresent(Id.self, forKey: .id)
		updated = try values.decodeIfPresent(Updated.self, forKey: .updated)
	//	category = try values.decodeIfPresent([Category].self, forKey: .category)
		title = try values.decodeIfPresent(Title.self, forKey: .title)
		//link = try values.decodeIfPresent([Link].self, forKey: .link)
	//	author = try values.decodeIfPresent([Author].self, forKey: .author)
		openSearch$totalResults = try values.decodeIfPresent(OpenSearch$totalResults.self, forKey: .openSearch$totalResults)
		openSearch$startIndex = try values.decodeIfPresent(OpenSearch$startIndex.self, forKey: .openSearch$startIndex)
		entry = try values.decodeIfPresent([Entry].self, forKey: .entry)
	}

}
