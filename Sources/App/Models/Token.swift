//
//  Token.swift
//  App
//
//  Created by 雷广 on 2018/10/9.
//

import Vapor
import FluentMySQL
import Crypto

final class Token: Codable {
    var id: UUID?
    var token: String
    var userID: User.ID 
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

extension Token: MySQLUUIDModel {}
extension Token: Content {}
extension Token: Migration {}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.userID)
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = try CryptoRandom().generateData(count: 16)
        return try Token(token: random.base64EncodedString(), userID: user.requireID())
    }
}
