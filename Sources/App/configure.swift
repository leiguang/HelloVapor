import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    
    // Note:
    /*
     Fatal error: Error raised at top level: ⚠️ MySQL Error: Unsupported auth plugin: caching_sha2_password
     See: https://github.com/vapor/fluent-mysql/issues/110
     Resolution:
     ```
        docker stop mysql
        docker rm mysql
        docker run --name mysql -e MYSQL_USER=leiguang  -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=vapor  -p 3306:3306 -d mysql/mysql-server:5.7
     ```
     */
    
    // Configure a MySQL database
    let databaseConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "leiguang", password: "password", database: "vapor")
    let database = MySQLDatabase(config: databaseConfig)

    /// Register the configured MySQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: database, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
//    migrations.add(model: Todo.self, database: .sqlite)
    migrations.add(model: Acronym.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Category.self, database: .mysql)
    migrations.add(model: AcronymCategoryPivot.self, database: .mysql)
    services.register(migrations)

}
