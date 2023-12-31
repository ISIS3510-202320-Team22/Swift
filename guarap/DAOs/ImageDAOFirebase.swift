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
    
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        if url == "" {
            completion(nil)
        }
        else if let storageUrl = URL(string: url), storageUrl.scheme == "gs" {
            // Firebase Storage URL
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: url)
            
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    completion(nil)
                } else {
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
        } else if let imageUrl = URL(string: url), imageUrl.scheme == "http" || imageUrl.scheme == "https" {
            // Regular HTTP/HTTPS URL
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    completion(nil)
                } else {
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
            }.resume()
        } else {
            print("Invalid URL format")
            completion(nil)
        }
    }
    
    func uploadImageToFirebase(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let imageID = UUID().uuidString // Generate a unique ID for the image
            let storageRef = Storage.storage().reference().child("images/\(imageID).jpg")
            
            // Upload the image
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // Image upload was successful
                    // You can access the download URL of the uploaded image
                    storageRef.downloadURL { (url, error) in
                        if let downloadURL = url {
                            completion(.success(downloadURL))
                        } else if let error = error {
                            completion(.failure(error))
                        }
                    }
                }
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
            completion(.failure(error))
        }
    }
}

enum ImageFetchError: Error {
    case downloadError
    case imageDataError
}
