//
//  Post.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    
    // Atributes of a post
    
    let id: String
    let ownerUid: String
    let title: String
    let description: String
    let ups: Int
    let downs: Int
    let image: String
    let timeStamp: Date
    let category: String
    
}
