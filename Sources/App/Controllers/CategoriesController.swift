//
//  CategoriesController.swift
//  App
//
//  Created by 雷广 on 2018/9/7.
//

import Vapor

struct CategoriesController: RouteCollection {
    
    func boot(router: Router) throws {
        let categoriesRoutes = router.grouped("api", "categories")
        categoriesRoutes.post(use: createHandler)
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.get(Category.parameter, use: getHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<Category> {
        return try req.content.decode(Category.self).flatMap(to: Category.self) { category in
            return category.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
}

