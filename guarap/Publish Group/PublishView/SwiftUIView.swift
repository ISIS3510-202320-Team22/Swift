//
//  SwiftUIView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 31/10/23.
//

import SwiftUI
import CoreLocation 
import MapKit


import SwiftUI
import MapKit
import CoreLocation

struct SwiftUIView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @StateObject var locationManager = LocationManager()

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .onAppear(perform: {
                locationManager.requestLocation()
                if let location = locationManager.lastKnownLocation {
                    region.center = location.coordinate
                }
            })
            .frame(height: 300) // Ajusta el tamaño según tus necesidades.
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
