//
//  CameraContentView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 27-09-2023.
//
// This view is the view that appears when a photo is being taken.

import SwiftUI

struct CustomCameraView: View {
    let cameraService = CameraService()
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    @State private var isFrontCamera = false
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case.success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Error: no image data found")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                    {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
                HStack {
                    Button(action: {
                                // Toggle between front and rear camera
                                isFrontCamera.toggle()
                                cameraService.switchCameraPosition(isFrontCamera)
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.largeTitle)
                                    .padding()
                                    .background(.black)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.bottom)
                }
                Button(action: {
                    cameraService.capturePhoto()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                })
                .padding(.bottom)
            }
        }
    }
}
