import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
   
    
    if let databaseURL = Environment.databaseURL,
           var postgresConfiguration = PostgresConfiguration(url: databaseURL)
        {
            postgresConfiguration.tlsConfiguration = .makeClientConfiguration()
            postgresConfiguration.tlsConfiguration?.certificateVerification = .none
            
            app.databases.use(
                .postgres(configuration: postgresConfiguration),
                as: .psql
            )
            
        } else {
            app.databases.use(
                .postgres(
                    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                    port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
                    username: Environment.get("DATABASE_USERNAME") ?? "postgres",
                    password: Environment.get("DATABASE_PASSWORD") ?? "naomie",
                    database: Environment.get("DATABASE_NAME") ?? "cvcreatordb"
                ),
                as: .psql
            )
        }

    app.migrations.add(CreateUser())
    
    try app.autoMigrate().wait()

    app.views.use(.leaf)

    

    // register routes
    try routes(app)
}
