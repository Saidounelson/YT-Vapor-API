import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    app.get("name") { req -> Int in
        return 12
    }
    try app.register(collection: SongContyroller())
}
