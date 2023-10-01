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
                                .background(.blue)
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
                                .foregroundColor(.white)
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
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                }
            }
            VStack {
                Spacer()
                Button(action: {
                    isCustomCameraViewPresented.toggle()
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(.black)
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
