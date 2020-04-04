

import Foundation
struct Json4Swift_Base : Decodable {
	let version : String?
	let encoding : String?
	let feed : Feed?

	enum CodingKeys: String, CodingKey {

		case version = "version"
		case encoding = "encoding"
		case feed = "feed"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		version = try values.decodeIfPresent(String.self, forKey: .version)
		encoding = try values.decodeIfPresent(String.self, forKey: .encoding)
		feed = try values.decodeIfPresent(Feed.self, forKey: .feed)
	}

}

struct Id : Codable {
    let t : String?

    enum CodingKeys: String, CodingKey {

        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

}
struct OpenSearch$startIndex : Codable {
    let t : String?

    enum CodingKeys: String, CodingKey {

        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

}

struct OpenSearch$totalResults : Codable {
    let t : String?

    enum CodingKeys: String, CodingKey {

        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

}
struct Updated : Codable {
    let t : String?

    enum CodingKeys: String, CodingKey {

        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

}
struct Content : Codable {
    let type : String?
    let t : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

}
struct Feed : Decodable {
    let xmlns : String?
    let xmlns$openSearch : String?
    let xmlns$gsx : String?
    let id : Id?
    let updated : Updated?
    // let category : [Category]?
    let title : Title?
//    let link : [Link]?
//    let author : [Author]?
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
    //    case author = "author"
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
    //    category = try values.decodeIfPresent([Category].self, forKey: .category)
        title = try values.decodeIfPresent(Title.self, forKey: .title)
        //link = try values.decodeIfPresent([Link].self, forKey: .link)
    //    author = try values.decodeIfPresent([Author].self, forKey: .author)
        openSearch$totalResults = try values.decodeIfPresent(OpenSearch$totalResults.self, forKey: .openSearch$totalResults)
        openSearch$startIndex = try values.decodeIfPresent(OpenSearch$startIndex.self, forKey: .openSearch$startIndex)
        entry = try values.decodeIfPresent([Entry].self, forKey: .entry)
    }

}
struct Title : Codable {
    let type : String?
    let t : String?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

}
struct Email : Codable {
    let t : String?

    enum CodingKeys: String, CodingKey {

        case t = "$t"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }

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
