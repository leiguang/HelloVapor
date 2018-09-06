//
//  UsersController.swift
//  App
//
//  Created by 雷广 on 2018/9/7.
//

import Vapor

struct UsersController: RouteCollection {
    
    func boot(router: Router) throws {
        let usersRoutes = router.grouped("api", "users")
        usersRoutes.post(use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(User.parameter, use: getHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self) { user in
            return user.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
}
