//
//  ContentView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 21/09/23.
//  Edited by Esteban Gonzalez Ruales
//

import SwiftUI

struct PublishView: View {
    @State private var passedOnImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack {
                Spacer()
                
                GeometryReader { geometry in
                    ZStack {
                        if let image = passedOnImage {
                            Image(uiImage: image)
                                .resizable()
                                //.aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 2) // Adjust the size as needed
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            Button(action: {
                                passedOnImage = nil // Delete the image
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white) // Set the color to blue
                                    .padding()
                            }
                        } else {
                            Button(action: {
                                isCustomCameraViewPresented.toggle()
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: geometry.size.width / 2,
                                               height: geometry.size.height / 2)
                                        .cornerRadius(10)
                                        
                                    
                                    Text("Click here to add\nan image to your post")
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.bottom)
                            .sheet(isPresented: $isCustomCameraViewPresented) {
                                CameraContentView(passedOnImage: $passedOnImage)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PublishView()
}

