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
    @State private var description = ""
    @State private var category = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    @State private var isBlockingUI = false

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack {
                Spacer()
                
                GeometryReader { geometry in
                    VStack {
                        HStack {
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
                            
                            TextField("Say whatever you want", text: $description)
                        }
                        TextField("Category", text: $category)
                            .padding()
                    }
                }
                
                Button(action: {
                    Task {
                        do {
                            try await Task.sleep(nanoseconds: 1)
                            let success = try await GuarapRepositoryImpl.shared.createPost(description: description, image: passedOnImage, category: category, latitude: latitude, longitude: longitude)
                            if success {
                                passedOnImage = nil
                                description = ""
                                category = ""
                                latitude = 0.0
                                longitude = 0.0
                            }
                        } catch {
                            print("Cannot upload post")
                        }
                        
                        isBlockingUI = false
                    }
                }, label: {
                    Text("Publish")
                })
            }
            
            if isBlockingUI {
                BlockingView()
            }
        }
    }
}

struct BlockingView: View {
    var body: some View {
        Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
    }
}

struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView()
    }
}

