//
//  ContentView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 21/09/23.
//  Edited by Esteban Gonzalez Ruales
//

import SwiftUI

struct ContentView: View {
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
                                .aspectRatio(contentMode: .fit)
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
                            Rectangle()
                                .fill(Color.gray)
//                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width / 2,
                                       height: geometry.size.height / 2)
                                .padding(.horizontal)
                                .padding(.trailing)
                                
                            Text("Add an image\nto your post")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.trailing)
                        }
                    }
                }
                
                Button(action: {
                    isCustomCameraViewPresented.toggle()
                }) {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented) {
                    CameraContentView(passedOnImage: $passedOnImage)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

