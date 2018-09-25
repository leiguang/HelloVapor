//import Vapor
//
///// Controls basic CRUD operations on `Todo`s.
//final class TodoController: RouteCollection {
//
//    func boot(router: Router) throws {
//
//        // Basic "Hello, world!" example
//        router.get("hello") { req in
//            //        return "Hello, world!"
//            return "喻聪真帅"
//        }
//
//        router.get("todos", use: index)
//        router.post("todos", use: create)
//        router.delete("todos", Todo.parameter, use: delete)
//
//
//        // MARK: - leiguang practices
//
//        router.get("hello", "vapor") { req in
//            return "Hello Vapor"
//        }
//
//        router.get("hello", String.parameter) { req -> String in
//            let name = try req.parameters.next(String.self)
//            return "Hello \(name)!"
//        }
//
//        router.post(InfoData.self, at: "info") { (req, data) in
//            return "Hello \(data.name)"
//        }
//
//        router.post(InfoData.self, at: "info/json") { (req, data) in
//            return InfoResponse(request: data)
//        }
//
//        router.get("date") { req in
//            return "\(Date())"
//        }
//
//        router.get("counter", Int.parameter) { req -> String in
//            let count = try req.parameters.next(Int.self)
//            return "count: \(count)"
//        }
//
//        router.post(UserInfoData.self, at: "user-info") { (req, data) in
//            return "Hello \(data.name), your are \(data.age)"
//        }
//
//    }
//
//    /// Returns a list of all `Todo`s.
//    func index(_ req: Request) throws -> Future<[Todo]> {
//        return Todo.query(on: req).all()
//    }
//
//    /// Saves a decoded `Todo` to the database.
//    func create(_ req: Request) throws -> Future<Todo> {
//        return try req.content.decode(Todo.self).flatMap { todo in
//            return todo.save(on: req)
//        }
//    }
//
//    /// Deletes a parameterized `Todo`.
//    func delete(_ req: Request) throws -> Future<HTTPStatus> {
//        return try req.parameters.next(Todo.self).flatMap { todo in
//            return todo.delete(on: req)
//        }.transform(to: .ok)
//    }
//}
//
//
//struct InfoData: Content {
//    let name: String
//}
//
//struct InfoResponse: Content {
//    let request: InfoData
//}
//
//struct CountJSON: Content {
//    let count: Int
//}
//
//struct UserInfoData: Content {
//    let name: String
//    let age: Int
//}
//
