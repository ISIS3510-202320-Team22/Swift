//
//  AboutUsView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 30-09-2023.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        Text("We are a group of students from the University of the Andes that want to make an app for the Uniandes community. Our purpose is to let everybody from the community to share posts and information through our platform.")
            .navigationTitle("About Us")
            .padding()
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
