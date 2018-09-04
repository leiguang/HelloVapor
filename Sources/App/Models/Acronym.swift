//
//  Acronym.swift
//  App
//
//  Created by 雷广 on 2018/9/4.
//

import FluentSQLite
import Vapor

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String

    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

extension Acronym: SQLiteModel {}
extension Acronym: Content {}
extension Acronym: Migration {}

//extension Acronym: Model {
//    typealias Database = SQLiteDatabase
//    typealias ID = Int
//    static let idKey: IDKey = \.id
//}


//struct Acronym: Codable {
//    var id: Int?
//    var short: String
//    var long: String
//
//    init(short: String, long: String) {
//        self.short = short
//        self.long = long
//    }
//}
