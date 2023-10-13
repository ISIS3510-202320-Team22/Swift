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
    
    // Post Atributes
    @State private var description = ""
    @State private var category = "Generic"
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    @State private var isBlockingUI = false
    
    // Image States
    @State private var passedOnImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @StateObject var viewModel = PublishViewModel()
    @Binding var tabIndex: Int
    
    // Dropdown Menu States
    @State private var isPopoverVisible = false
    @State private var selectedOption: String = "Select a Category"
    let options = ["chismes", "atardeceres"]
    
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    var body: some View {
        
        VStack{
            // Guarap Title
            Text("Guarap")
                .padding(.top, 15)
                .font(.system(size: 35))
            Divider()
            // Cancel Button
            HStack{
                Spacer()
                Button{
                    description = ""
                    passedOnImage = nil
                    tabIndex = 0
                } label: {
                    Text("Cancel")
                        .font(.system(size: 25))
                        .foregroundColor(guarapColor)
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
                    TextField("Enter your description", text: $description, axis: .vertical)
                        .frame(maxWidth: .infinity) // Expand to fill the width
                        .padding(.trailing, 15)
                    
                }
                
            }// End of Image and Text
            .frame(height: 300)
            Divider()
            // Categories tags
            HStack {
                Text("Category Tag")
                Spacer()
                // Pulldown Button
                VStack {
                    TextField("Category", text: $category)
                        .padding()
//                    Button(action: {
//                        isPopoverVisible.toggle()
//                    }) {
//                        Text(selectedOption)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(guarapColor)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .popover(isPresented: $isPopoverVisible, arrowEdge: .top) {
//                        List {
//                            ForEach(options, id: \.self) { option in
//                                Button(action: {
//                                    selectedOption = option
//                                    category = option
//                                    isPopoverVisible.toggle()
//                                }) {
//                                    Text(option)
//                                }
//                            }
//                        }.foregroundColor(.black)
//                    }
                }// End Pulldown Button
                .padding()
            }
            .padding(.horizontal, 15)
            
            Spacer()
            
            // Share button
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
                            tabIndex = 0
                        }
                    } catch {
                        print("Cannot upload post")
                    }
                    
                    isBlockingUI = false
                }
            }) {
                Text("Share")
                    .foregroundColor(.white)
                    .padding()
                    .background(guarapColor)
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

