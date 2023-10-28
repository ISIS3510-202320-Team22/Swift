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
    @State private var category = DEFAULT_CATEGORY
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
    @State private var selectedOption: String = "Select a category"
    
    @State private var showSuccessBanner = false
    @State private var showFailureBanner = false

    
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    // Guarap Title
                    Text("Guarap")
                        .padding(.top, 15)
                        .font(.system(size: 35))
                    Divider()
                    // Cancel Button
                    HStack{
                        Spacer()
                        Button {
                            description = ""
                            category = DEFAULT_CATEGORY
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
                            TextField("Enter your description", text: $description)
                                .frame(maxWidth: .infinity) // Expand to fill the width
                                .padding(.trailing, 15)
                                .onChange(of: description) { newValue in
                                    if newValue.count > MAX_DESCRIPTION_CHAR_LIMIT {
                                        description = String(newValue.prefix(MAX_DESCRIPTION_CHAR_LIMIT))
                                    }
                                }
                                .onSubmit {
                                    description = description.trimmingCharacters(in: .whitespacesAndNewlines)
                                }
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
                            Button(action: {
                                isPopoverVisible.toggle()
                            }) {
                                Text(selectedOption)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(guarapColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .popover(isPresented: $isPopoverVisible, arrowEdge: .top) {
                                List {
                                    ForEach(categories, id: \.self) { option in
                                        Button(action: {
                                            selectedOption = option
                                            category = option
                                            isPopoverVisible.toggle()
                                        }) {
                                            Text(option)
                                        }
                                    }
                                }.foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 15)
                    }// End Pulldown Button
                    .padding()
                    
                    Spacer()
                    
                    // Share button
                    Button(action: {
                        Task {
                            do {
                                isBlockingUI = true
                                print(345)
                                //try await Task.sleep(nanoseconds: 2000000000)
                                let _: () = GuarapRepositoryImpl.shared.createPost(description: description.trimmingCharacters(in: .whitespacesAndNewlines), image: passedOnImage, category: category, latitude: latitude, longitude: longitude) { success in
                                    
                                    if success {
                                        passedOnImage = nil
                                        description = ""
                                        category = ""
                                        latitude = 0.0
                                        longitude = 0.0
                                        isBlockingUI = false
                                        showSuccessBanner = true
                                        hideBannerAfterDelay(3) // Show success banner for 3 seconds
                                        isBlockingUI = false
                                    } else {
                                        showFailureBanner = true
                                        hideBannerAfterDelay(3) // Show failure banner for 3 seconds
                                        isBlockingUI = false
                                    }
                                }
                            }
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
            .disabled(isBlockingUI)
            
            if isBlockingUI {
                Color.black.opacity(0.5) // Fondo oscuro detrás de la pantalla de carga
                ProgressView() // Pantalla de carga
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            
            if showSuccessBanner {
                BannerView(text: "Post successfuly uploaded", color: .green)
            }

            if showFailureBanner {
                BannerView(text: "Failure uploading post\nCheck there is at least an image or text", color: .red)
            }
        }
    }
    
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showSuccessBanner = false
            showFailureBanner = false
        }
    }
}



struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView( tabIndex: .constant(0))
    }
}

