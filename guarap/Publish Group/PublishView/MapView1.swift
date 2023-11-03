//
//  SwiftUIView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 31/10/23.
//

import SwiftUI
import CoreLocation
import MapKit
import CoreLocation

import SwiftUI
import CoreLocation

struct MapView1: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 4.6097, longitude: -74.0817),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @StateObject var locationManager = LocationManager()
    @State private var address: String?
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .onAppear(perform: {
                    locationManager.requestLocation()
                    if let location = locationManager.lastKnownLocation {
                        region.center = location.coordinate
                        reverseGeocode(location: location)
                    }
                })
                .frame(width: 250, height: 250)
            
            Button(action: {
                if let address = address {
                    // Aquí puedes usar la dirección para compartir
                    print("Dirección: \(address)")
                }
            }) {
                Text("Share")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
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
                    self.address = "\(name), \(locality), \(administrativeArea) \(postalCode), \(country)"
                } else {
                    self.address = "Dirección no disponible"
                }
            } else {
                self.address = "Dirección no disponible"
            }
        }
    }
}




struct MapView1_Previews: PreviewProvider {
    static var previews: some View {
        MapView1()
    }
}
