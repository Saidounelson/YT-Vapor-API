//
//  CreateSongs.swift
//  
//
//  Created by Saidou on 05/06/2022.
//

import Fluent

struct CreateSongs:Migration{
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return database.schema("songs")
            .id()
            .field("title",.string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        
        return database.schema("songs").delete()
    }
    
    
}
