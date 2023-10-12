//
//  ContentView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 21/09/23.
//  Edited by Esteban Gonzalez Ruales
//  Re edited by Juan Diego Calixto on 11/10/23.
//

import SwiftUI

struct PublishView: View {
    
    @State private var passedOnImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @State private var caption = ""
    @StateObject var viewModel = PublishViewModel()
    @Binding var tabIndex: Int
    
    var body: some View {
        
        VStack{
            // Guarap Title
            Text("Guarap")
                .padding(.top, 15)
                .font(.system(size: 35))
            
            // Cancel Button
            HStack{
                Spacer()
                Button{
                    caption = ""
                    passedOnImage = nil
                    tabIndex = 0
                } label: {
                    Text("Cancel")
                        .font(.system(size: 25))
                }
            }.padding(.trailing, 15)
            
            // Post Title
            Text("New Post")
                .font(.system(size: 25))
            
            // Image and Text
            
            HStack{
                // Image
                ZStack {
                    if let image = passedOnImage {
                        Image(uiImage: image)
                            .resizable()
                        //.aspectRatio(contentMode: .fit)
                        //.frame(width: geometry.size.width / 2, height: geometry.size.height / 2) // Adjust the size as needed
                            .padding(15)
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
                                .foregroundColor(.blue) // Set the color to blue
                                .clipped()
                                .padding()
                        }
                    } else {
                        Button(action: {
                            isCustomCameraViewPresented.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray)
                                    .cornerRadius(10)
                                    .padding(15)
                                
                                Text("Click here to add\nan image to your post")
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 15)
                            }
                        }
                        .padding(.bottom)
                        .sheet(isPresented: $isCustomCameraViewPresented) {
                            CameraContentView(passedOnImage: $passedOnImage)
                        }
                    }
                }// End of Image
                
                // Text
                VStack{
                    TextField("Enter your description", text: $caption, axis: .vertical)
                        .frame(maxWidth: .infinity) // Expand to fill the width
                        .padding(.trailing, 15)
                    
                }
                
            }// End of Image and Text
            .frame(height: 350)
            
            // Categories tags
            HStack {
                Text("Categories")
                Spacer()
                Text("Aqui van las categorías")
            }
            .padding(.horizontal, 15)
            
            Spacer()
            
            // Share button
            Button(action: {
                // Action to perform when the button is tapped
                print("Button tapped!")
            }) {
                Text("Share")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(15)
            }
            .frame(width: 300, height: 50)
            Spacer()
        } // End of VStack
    }
}

struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView( tabIndex: .constant(0))
    }
}

