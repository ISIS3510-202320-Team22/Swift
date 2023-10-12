//
//  User.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 12/10/23.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String

}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "batman", profileImageUrl: "xxx", fullname: "aaaa", bio: "hola", email: "aaa@gmail.com"),
        .init(id: NSUUID().uuidString, username: "bbbb", profileImageUrl: "xxx", fullname: "aaabbba", bio: "bbbb", email: "bbb@gmail.com")
    
    ]
}
