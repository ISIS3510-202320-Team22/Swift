//
//  PostWithImage.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 30-10-2023.
//

import Foundation
import SwiftUI

struct PostWithImage: Identifiable {
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
    let uiimage: UIImage?
}
