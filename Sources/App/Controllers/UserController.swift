import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users") 
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { user in
            user.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [User] {
        return try await User.query(on: req.db).all()
    }

    func create(req: Request) async throws -> HTTPStatus  {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return .created
    }

    func delete(req: Request) async throws -> HTTPStatus {
        
        let userIdToDelete: UUID? = req.parameters.get("userID")
        
        guard let userToDelete = try? await User.find(userIdToDelete, on: req.db) else {
            return .notFound
        }
        
        try await userToDelete.delete(on: req.db)
        
        return .ok
    }
}
