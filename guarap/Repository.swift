//
//  Repository.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation

protocol Repository {
    func getPostsFromCategory(name: String)
    func publishPost(title: String, description: String, image: ImageResource?, user: String)
}
