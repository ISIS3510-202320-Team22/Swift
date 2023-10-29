//
//  ProfileView.swift
//  guarap
//
//  Created by Nathalia Quiroga 2/10/23.
//

import SwiftUI

struct AccountView: View {
    
    @AppStorage("username") var username = ""
    @State private var showNoInternetBanner = false
    @ObservedObject var networkManager = NetworkManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer()
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
                                if networkManager.isOnline {
                                    AuthService.shared.signOut()
                                } else {
                                    showNoInternetBanner = true
                                    hideBannerAfterDelay(3)
                                }
                            } label: {
                                Text("Sign Out")
                            }
                            .padding()
                        }
                        
                        Text("Guarap")
                            .font(.title)
                        
                        VStack(alignment: .center) { // Añade alignment: .center aquí
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 200, height: 200)
                            Text(username)
                                .font(.system(size: 30))
                        }
                        
                        Spacer()
                    }
                }
                
                if showNoInternetBanner {
                    BannerView(text: "Currently there is no internet connection.\nSign out later.", color: .yellow)
                }
            }
        }
    }
    
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showNoInternetBanner = false
        }
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
