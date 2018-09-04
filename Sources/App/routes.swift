import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
//        return "Hello, world!"
        return "喻聪真帅"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    
    // MARK: - leiguang practices
    
    router.get("hello", "vapor") { req in
        return "Hello Vapor"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello \(name)!"
    }
    
    router.post(InfoData.self, at: "info") { (req, data) in
        return "Hello \(data.name)"
    }
    
    router.post(InfoData.self, at: "info/json") { (req, data) in
        return InfoResponse(request: data)
    }
    
    router.get("date") { req in
        return "\(Date())"
    }
    
    router.get("counter", Int.parameter) { req -> String in
        let count = try req.parameters.next(Int.self)
        return "count: \(count)"
    }
    
    router.post(UserInfoData.self, at: "user-info") { (req, data) in
        return "Hello \(data.name), your are \(data.age)"
    }
    
    // MARK: - Acronyms
    
    let acronymsController = AcronymsController()
    try router.register(collection: acronymsController)
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

struct CountJSON: Content {
    let count: Int
}

struct UserInfoData: Content {
    let name: String
    let age: Int
}
