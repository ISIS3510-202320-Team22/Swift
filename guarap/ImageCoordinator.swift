//
//  ImageCoordinator.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 29-09-2023.
//

import SwiftUI

class ImageCoordinator: ObservableObject {
    @Published var capturedImage: UIImage?
    
    func captureImage(_ image: UIImage) {
        capturedImage = image
    }
    
    func dismissImage() {
        capturedImage = nil
    }
}
