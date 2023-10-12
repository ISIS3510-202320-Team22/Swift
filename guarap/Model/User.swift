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
