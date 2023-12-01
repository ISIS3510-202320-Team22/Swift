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
    @StateObject private var userLocationManager = mapViewModel()
    
    
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
    
    // Ad States
    @State private var isAdViewPresented = false
    
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
                    
                    // Change to ad view
                    Button(action: {
                        isAdViewPresented.toggle()
                    }) {
                        Text("I want to post an ad")
                            .font(.system(size: 15))
                            .foregroundColor(guarapColor)
                            .padding()
                    }
                    .padding(.bottom)
                    .sheet(isPresented: $isAdViewPresented) {
                        AdView()
                    }
                    
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
                            TextField("300 char description", text: $description)
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
                                    ForEach(categories.filter { $0 != "Promociones" }, id: \.self) { option in
                                        Button(action: {
                                            selectedOption = option
                                            category = option
                                            isPopoverVisible.toggle()
                                        }) {
                                            Text(option)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 15)
                    }// End Pulldown Button
                    .padding()
                    
                    
                    Spacer()
                    
                    // Share button
                    // ... (dentro del cuerpo de tu Vista)
                    
                    Button(action: {
                        Task {
                            do {
                                description = description.trimmingCharacters(in: .whitespacesAndNewlines)
                                isBlockingUI = true
                                print(345)
                                if networkManager.isOnline {
                                    
                                    // Obtener la dirección actual
                                    userLocationManager.getAddressFromCoordinates { obtainedAddress in
                                        if let obtainedAddress = obtainedAddress {
                                            print("Dirección obtenida: \(obtainedAddress)")
                                            // Usar la dirección obtenida para subir el post
                                            let _: () = GuarapRepositoryImpl.shared.createPost(description: description.trimmingCharacters(in: .whitespacesAndNewlines), image: passedOnImage, category: category, address: obtainedAddress) { success in
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
                                            // Manejar el caso en el que no se pudo obtener la dirección
                                            // (puede que no haya conexión, etc.)
                                            print("No se pudo obtener la dirección actual.")
                                            // Resto de tu lógica...
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
                    
                    
                    //MAPA 2.0 --------------
                    VStack {
                        Map(coordinateRegion: $userLocationManager.region, showsUserLocation: true)
                            .ignoresSafeArea()
                            .accentColor(guarapColor)
                            .onAppear{
                                userLocationManager.checkIfLocationServicesIsEnable()
                            }
                            .frame(width: 250, height: 250)
                    }
                    
                    
                }
                // End of VStack
            }
            .disabled(isBlockingUI)
            //            .alert("Error", isPresented: $locationManager.showError) {
            //                        Button("OK", role: .cancel) {}
            //                    }
            
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

final class mapViewModel: NSObject ,ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.6097, longitude: -74.0817),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnable ( ) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        } else {
            print("Show an alert letting them know this is off and to go turn it on.")
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
    func getAddressFromCoordinates(completion: @escaping (String?) -> Void) {
        guard let locationManager = locationManager else { return }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(locationManager.location!) { placemarks, error in
                if let error = error {
                    print("Error getting address: \(error.localizedDescription)")
                    completion(nil)
                } else if let placemark = placemarks?.first {
                    let address = "\(placemark.thoroughfare ?? ""), \(placemark.subThoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
                    completion(address)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion("") // Si no hay permisos, envía una cadena vacía
        }
    }
    
    
}
