//
//  AcronymCategoryPivot.swift
//  App
//
//  Created by 雷广 on 2018/9/10.
//

//import Foundation
import FluentSQLite
import Vapor

final class AcronymCategoryPivot: SQLiteUUIDPivot {
    var id: UUID?
    var acronymID: Acronym.ID
    var categoryID: Category.ID

    typealias Left = Acronym
    typealias Right = Category

    static let leftIDKey: LeftIDKey = \.acronymID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(_ acronymID: Acronym.ID, _ categoryID: Category.ID) {
        self.acronymID = acronymID
        self.categoryID = categoryID
    }
}

extension AcronymCategoryPivot: Migration {}
