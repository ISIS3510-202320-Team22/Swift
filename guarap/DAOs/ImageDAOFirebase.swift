//
//  ImageDAOImpl.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 04-10-2023.
//

import Foundation
import SwiftUI
import FirebaseStorage

class ImageDAOFirebase: ImageDAO {
    
    private init(){}
    
    static var shared: ImageDAO = ImageDAOFirebase()
    
    let firebaseProject = "gs://isis3510-guarap.appspot.com/"
    
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: firebaseProject + url)

        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
            } else {
                // Successfully downloaded image data
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        completion(image)
                    } else {
                        print("Error creating UIImage from data")
                        completion(nil)
                    }
                } else {
                    print("No image data found")
                    completion(nil)
                }
            }
        }
    }
}

enum ImageFetchError: Error {
    case downloadError
    case imageDataError
}
