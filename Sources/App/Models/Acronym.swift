//
//  Acronym.swift
//  App
//
//  Created by 雷广 on 2018/9/4.
//

import FluentMySQL
import Vapor

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    var creatorID: User.ID
    
    init(short: String, long: String, creatorID: User.ID) {
        self.short = short
        self.long = long
        self.creatorID = creatorID
    }
}

extension Acronym: MySQLModel {}
extension Acronym: Content {}
extension Acronym: Migration {}
extension Acronym: Parameter {}

extension Acronym {
    var creator: Parent<Acronym, User> {
        return parent(\.creatorID)
    }
    
    var categories: Siblings<Acronym, Category, AcronymCategoryPivot> {
        return siblings()
    }
}

//extension Acronym: Model {
//    typealias Database = SQLiteDatabase
//    typealias ID = Int
//    static let idKey: IDKey = \.id
//}
