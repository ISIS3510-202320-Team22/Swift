//
//  Post.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    var id: UUID
    
    
    // Atributes of a post
    
    let user: String
    let description: String
    var upVotes: Int
    var downVotes: Int
    let reported: Bool
    let image: String
    let address: String
    let dateTime: Date
}
