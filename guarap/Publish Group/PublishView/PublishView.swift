//
//  ContentView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 21/09/23.
//  Edited by Esteban Gonzalez Ruales
//  Re edited by Juan Diego Calixto on 11/10/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct PublishView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.6097, longitude: -74.0817),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @StateObject var locationManager = LocationManager()
    @State private var selectedAddress: String?
    @State private var address = ""

    
    // Post Atributes
    @State private var description = ""
    @State private var category = DEFAULT_CATEGORY
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
    @State private var showNoInternetBanner = false
    @ObservedObject var networkManager = NetworkManager.shared
    
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Spacer()
                    // Cancel Button
                    HStack {
                        if networkManager.isConnectionBad {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                    .padding(.leading)
                            Text("Slow connection")
                        }
                        
                        if !networkManager.isOnline {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .padding(.leading)
                            Text("No connection")
                        }
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
                                                .foregroundColor(.red)
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
                                if networkManager.isOnline {
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
                    
                    //MAPA --------------
//                    VStack {
//                        Map(coordinateRegion: $region, showsUserLocation: true)
//                            .onAppear(perform: {
//                                locationManager.requestLocation()
//                                if let location = locationManager.lastKnownLocation {
//                                    region.center = location.coordinate
//                                    reverseGeocode(location: location)
//                                }
//                            })
//                            .frame(width: 250, height: 250)
//                        
//                        Button(action: {
//                            if let selectedAddress = selectedAddress {
//                                // Aquí puedes usar la dirección para compartir
//                                address = selectedAddress
//                                print("Dirección: \(selectedAddress)")
//                            }
//                        }) {
//                            Text("Share")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                        }
//                    }
                    
                    
                    
                    
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

    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                if let name = placemark.name,
                   let locality = placemark.locality,
                   let administrativeArea = placemark.administrativeArea,
                   let postalCode = placemark.postalCode,
                   let country = placemark.country {
                    self.selectedAddress = "\(name), \(locality), \(administrativeArea) \(postalCode), \(country)"
                } else {
                    self.selectedAddress = "Dirección no disponible"
                }
            } else {
                self.selectedAddress = "Dirección no disponible"
            }
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



struct PublishView_Previews: PreviewProvider {
    static var previews: some View {
        PublishView( tabIndex: .constant(0))
    }
}

