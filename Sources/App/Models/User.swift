import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "first_name")
    var firstName: String
    
//    @Field(key: "last_name")
//    var lastName: String

    init() { }

    init(id: UUID? = nil, firstName: String) {
        self.id = id
        self.firstName = firstName
    }
}
