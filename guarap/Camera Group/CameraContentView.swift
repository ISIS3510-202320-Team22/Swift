//
//  CameraContentView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 27-09-2023.
//

import SwiftUI

struct CameraContentView: View {
    @Binding var passedOnImage: UIImage?
    @State var capturedImage: UIImage?
    @State private var isCustomCameraViewPresented = false
    @Environment(\.presentationMode) var presentationMode
    
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    var body: some View {
        ZStack {
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button(action: {
                            // Pass the captured image to the parent view or perform any desired actions here
                            passedOnImage = capturedImage
                            presentationMode.wrappedValue.dismiss() // Dismiss the view
                        }) {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(guarapColor)
                                .cornerRadius(10)
                        }
                        .padding()
                        Spacer()
                        Button(action: {
                            capturedImage = nil // Dismiss the image
                            //presentationMode.wrappedValue.dismiss() // Dismiss the view
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24))
                                .foregroundColor(guarapColor)
                                .padding()
                        }
                    }
                    Spacer()
                }
            } else {
                ZStack {
                    Color(UIColor.systemBackground)
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Dismiss the view
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(guarapColor)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                }
            }
            VStack {
                Spacer()
                if capturedImage == nil {
                    Text("Press the camera icon to take a photo")
                        .padding()
                        .foregroundColor(guarapColor)
                }
                    
                Button(action: {
                    isCustomCameraViewPresented.toggle()
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(guarapColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                })
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented, content: {
                    CustomCameraView(capturedImage: $capturedImage)
                })
            }
        }
    }
}
