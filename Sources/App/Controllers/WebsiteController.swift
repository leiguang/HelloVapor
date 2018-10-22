//
//  WebsiteController.swift
//  App
//
//  Created by 雷广 on 2018/9/27.
//

import Vapor
import Leaf
import Authentication

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())
        
        authSessionRoutes.get(use: indexHandler)
        authSessionRoutes.get("acronyms", Acronym.parameter, use: acronmyHandler)
        authSessionRoutes.get("users", User.parameter, use: userHandler)
        authSessionRoutes.get("users", use: allUsersHandler)
        authSessionRoutes.get("categories", Category.parameter, use: categoryHandler)
        authSessionRoutes.get("categories", use: allCategoriesHandler)
        authSessionRoutes.get("login", use: loginHandler)
        authSessionRoutes.post("login", use: loginPostHandler)
        
        
        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<User>(path: "/login"))
        protectedRoutes.get("create-acronym", use: createAcronymHandler)
        protectedRoutes.post("create-acronym", use: createAcronymPostHandler)
        protectedRoutes.get("acronyms", Acronym.parameter, "edit", use: editAcronymHandler)
        protectedRoutes.post("acronyms", Acronym.parameter, "edit", use: editAcronymPostHandler)
        protectedRoutes.post("acronyms", Acronym.parameter, "delete", use: deleteAcronymHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        return Acronym.query(on: req).all().flatMap(to: View.self) { acronyms in
            let context = IndexContent(title: "Homepage", acronyms: acronyms.isEmpty ? nil : acronyms)
            return try req.leaf().render("index", context)
        }
    }
    
    func acronmyHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Acronym.self).flatMap(to: View.self) { acronym in
            return try flatMap(to: View.self, acronym.creator.get(on: req), acronym.categories.query(on: req).all()) { creator, categories in
                let context = AcronymContext(title: acronym.long, acronym: acronym, creator: creator, categories: categories)
                return try req.leaf().render("acronym", context)
            }
        }
    }
    
    func userHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(User.self).flatMap(to: View.self) { user in
            return try user.acronyms.query(on: req).all().flatMap(to: View.self) { acronyms in
                let context = UserContext(title: user.name, user: user, acronyms: acronyms.isEmpty ? nil : acronyms)
                return try req.leaf().render("user", context)
            }
        }
    }
    
    func allUsersHandler(_ req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap(to: View.self) { users in
            let context = AllUsersContext(title: "All Users", users: users)
            return try req.leaf().render("allUsers", context)
        }
    }
    
    func categoryHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Category.self).flatMap(to: View.self) { category in
            return try category.acronyms.query(on: req).all().flatMap(to: View.self) { acronyms in
                let context = CategoryContext(title: category.name, category: category, acronyms: acronyms)
                return try req.leaf().render("category", context)
            }
        }
    }
    
    func allCategoriesHandler(_ req: Request) throws -> Future<View> {
        return Category.query(on: req).all().flatMap(to: View.self) { categories in
            let context = AllCategoriesContext(title: "All Categories", categories: categories)
            return try req.leaf().render("allCategories", context)
        }
    }
    
    func createAcronymHandler(_ req: Request) throws -> Future<View> {
        let context = CreateAcronymContext(titles: "Create An Acronym")
        return try req.leaf().render("createAcronym", context)
    }
    
    func createAcronymPostHandler(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(AcronymPostData.self).flatMap(to: Response.self) { data in
            let user = try req.requireAuthenticated(User.self)
            let acronym = try Acronym(short: data.acronymShort, long: data.acronymLong, creatorID: user.requireID())
            return acronym.save(on: req).map(to: Response.self) { acronym in
                guard let id = acronym.id else {
                    return req.redirect(to: "/")
                }
                return req.redirect(to: "/acronyms/\(id)")
            }
        }
    }
    
    func editAcronymHandler(_ req: Request) throws -> Future<View> {
        return try req.parameters.next(Acronym.self).flatMap(to: View.self) { acronym in
            let context = EditAcronymContext(title: "Edit Acronym", acronym: acronym)
            return try req.leaf().render("createAcronym", context)
        }
    }
    
    func editAcronymPostHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Acronym.self), req.content.decode(AcronymPostData.self)) { acronym, data in
            acronym.short = data.acronymShort
            acronym.long = data.acronymLong
            acronym.creatorID = try req.requireAuthenticated(User.self).requireID()
            
            return acronym.save(on: req).map(to: Response.self) { acronym in
                guard let id = acronym.id else {
                    return req.redirect(to: "/")
                }
                return req.redirect(to: "/acronyms/\(id)")
            }
        }
    }
    
    func deleteAcronymHandler(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Acronym.self).flatMap(to: Response.self) { acronym in
            return acronym.delete(on: req).transform(to: req.redirect(to: "/"))
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<View> {
        let context = LoginContext(title: "Log In")
        return try req.leaf().render("login", context)
    }
    
    func loginPostHandler(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(LoginPostData.self).flatMap(to: Response.self) { data in
            let verifier = try req.make(BCryptDigest.self)
            return User.authenticate(username: data.username, password: data.password, using: verifier, on: req).map(to: Response.self) { user in
                guard let user = user else {
                    return req.redirect(to: "/login")
                }
                try req.authenticateSession(user)
                return req.redirect(to: "/")
            }
        }
    }
}

extension Request {
    func leaf() throws -> LeafRenderer {
        return try self.make(LeafRenderer.self)
    }
}

struct IndexContent: Encodable {
    let title: String
    let acronyms: [Acronym]?
}

struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let creator: User
    let categories: [Category]
}

struct UserContext: Encodable {
    let title: String
    let user: User
    let acronyms: [Acronym]?
}

struct AllUsersContext: Encodable {
    let title: String
    let users: [User]
}

struct CategoryContext: Encodable {
    let title: String
    let category: Category
    let acronyms: [Acronym]
}

struct AllCategoriesContext: Encodable {
    let title: String
    let categories: [Category]
}

struct CreateAcronymContext: Encodable {
    let titles: String
}

struct AcronymPostData: Content {
    static var defaultMediaType = MediaType.urlEncodedForm
    let acronymLong: String
    let acronymShort: String
}

struct EditAcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let editing = true
}

struct LoginContext: Encodable {
    let title: String
}

struct LoginPostData: Content {
    let username: String
    let password: String
}
