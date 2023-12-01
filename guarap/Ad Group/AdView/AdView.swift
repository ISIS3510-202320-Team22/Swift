//
//  AdView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 30/11/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct AdView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.6097, longitude: -74.0817),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @StateObject var locationManager = LocationManager()
    @State private var selectedAddress: String?
    @State private var address = ""
    
    
    // Post Atributes
    @State private var description = ""
    @State private var category = "Promociones"
    @State private var isBlockingUI = false
    
    // Image States
    @State private var passedOnImage: UIImage? = nil
    @State private var isCustomCameraViewPresented = false
    @StateObject var viewModel = PublishViewModel()
    @State private var isImagePickerPresented = false
    
    // Dropdown Menu States
    @State private var isPopoverVisible = false
    @State private var selectedOption: String = "Select a category" // ELIMINAR DESPUES
    @State private var selectedAmount: String = "$5,000"
    private let amounts = ["$5,000","$10,000","$20,000","$50,000","$100,000"]
    
    @State private var showSuccessBanner = false
    @State private var showFailureBanner = false
    @State private var showNoInternetBanner = false
    @ObservedObject var networkManager = NetworkManager.shared
    
    // Initializing the color of the app
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Spacer()
                    
                    // Post Title
                    Text("Post your ad")
                        .font(.system(size: 25))
                    
                    // Image and Text
                    
                    HStack{
                        // Image
                        ZStack {
                            if let image = passedOnImage {
                                Image(uiImage: image)
                                    .resizable()
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
                                    isImagePickerPresented.toggle()
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
                                .sheet(isPresented: $isImagePickerPresented) {
                                    ImagePicker(selectedImage: $passedOnImage, isPresented: $isImagePickerPresented)
                                }
                            }
                        } // End of Image
                        
                        // Text
                        VStack{
                            TextField("Enter your ad description", text: $description)
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
                    
                    // Amount Selection
                    HStack {
                        Text("Select Amount:")
                            .padding(.trailing, 10)
                        
                        Picker("Amount", selection: $selectedAmount) {
                            Text("$5,000").tag("$5,000")
                            Text("$10,000").tag("$10,000")
                            Text("$20,000").tag("$20,000")
                            Text("$50,000").tag("$50,000")
                            Text("$100,000").tag("$100,000")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Share button
                    Button(action: {
                        Task {
                            do {
                                isBlockingUI = true
                                print(345)
                                if networkManager.isOnline {
                                    let likes = try translateAmountToLikes(amount: selectedAmount)
                                    let _: () = GuarapRepositoryImpl.shared.createPost(description: description.trimmingCharacters(in: .whitespacesAndNewlines), image: passedOnImage, category: category, address: address) { success in
                                        
                                        if success {
                                            passedOnImage = nil
                                            description = ""
                                            category = ""
                                            address = ""
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
                                } else {
                                    showNoInternetBanner = true
                                    hideBannerAfterDelay(3)
                                    isBlockingUI = false
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
                }
                // End of VStack
            }
            .disabled(isBlockingUI)
            
            if isBlockingUI {
                Color.black.opacity(0.5) // Fondo oscuro detrás de la pantalla de carga
                ProgressView() // Pantalla de carga
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            
            if showSuccessBanner {
                BannerView(text: "Post successfuly uploaded.", color: .green)
            }
            
            if showFailureBanner {
                BannerView(text: "Failure uploading post\nCheck there is at least an image or text.", color: .red)
            }
            
            if showNoInternetBanner {
                BannerView(text: "Currently there is no internet connection.\nTry again later.", color: .yellow)
            }
        }
    }
    
    // Function to calculate the number of likes depending on the amount donated
    func translateAmountToLikes(amount: String) throws -> Int {
        switch amount {
        case "$5,000":
            return 10
        case "$10,000":
            return 20
        case "$20,000":
            return 40
        case "$50,000":
            return 100
        case "$100,000":
            return 200
        default:
            return 10
        }
    }
    
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showSuccessBanner = false
            showFailureBanner = false
            showNoInternetBanner = false
        }
    }
}

