import Fluent
import Vapor

struct LoginResponse: Content {
    let isSuccess: Bool
}

struct LoginRequestBody: Content {
    let username: String
    let password: String
}


struct SignUpResponse: Content {
    let isSuccess: Bool
}

struct SignUpRequestBody: Content {
    let username: String
    let email: String
    let password: String
    let passwordConfirmation: String
}


func routes(_ app: Application) throws {
    
    // MARK:
    app.get("") { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }

    
    
    
    app.post("api", "v1", "login") { req -> LoginResponse in
        guard let bodyData = req.body.data else {
            throw Abort(.badRequest)
        }

        let decodedData = try JSONDecoder().decode(LoginRequestBody.self, from: bodyData)
        
    
        guard let user = try await User
            .query(on: req.db)
            .filter(User.self, \.$username == decodedData.username)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        let loginHashedPassword = try Bcrypt.hash(decodedData.password)
        
        guard user.passwordHash == loginHashedPassword else {
            throw Abort(.unauthorized)
        }
        
        return LoginResponse(isSuccess: true)
    }
    
    
    app.post("api", "v1", "signup") { req -> SignUpResponse in
        guard let bodyData = req.body.data else {
            throw Abort(.badRequest)
        }
        
        
        
        let decodedData = try JSONDecoder().decode(SignUpRequestBody.self, from: bodyData)
        
        
        guard decodedData.password == decodedData.passwordConfirmation else {
            throw Abort(.badRequest, reason: "Password and password confirmation are different")
        }
        
        
        let user = User(
            username: decodedData.username,
            email: decodedData.email,
            passwordHash: try Bcrypt.hash(decodedData.password)
        )
        
        
        try await user.save(on: req.db)
        
        
        
        return SignUpResponse(isSuccess: true)
    }

    try app.register(collection: UserController())
}
