//
//  Category.swift
//  App
//
//  Created by 雷广 on 2018/9/7.
//

import FluentSQLite
import Vapor

final class Category: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Category: SQLiteModel {}
extension Category: Migration {}
extension Category: Content {}
extension Category: Parameter {}