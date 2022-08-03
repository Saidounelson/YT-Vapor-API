//
//  SongController.swift
//  
//
//  Created by Saidou on 05/06/2022.
//

import Fluent
import Vapor

struct SongContyroller:RouteCollection{
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID"){ song in
            song.delete(use:delete)
        }
    }
    // Songs route
    func index(req:Request)  throws ->EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    // POST /songs route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
    // PUT Request /songs/id  route
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return Song.find(song.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.title = song.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    // DELETE Request /songs/id
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound,reason: "Name must not be empty."))
            .flatMap {$0.delete(on: req.db)}
            .transform(to: .ok)
    }
    
}
