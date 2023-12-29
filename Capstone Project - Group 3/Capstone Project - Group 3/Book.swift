
import Foundation

import ParseSwift

struct BookResponse: Decodable {
    let books: [Book]
}

struct Book: ParseObject {
    
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var author: String?
    var book_id: Int?
    var cover: String?
    var name: String?
    var url: String?
    var status: String?
    var User: User?
    
    //var description: String?
}



