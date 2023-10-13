//
//  MainTabView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    var body: some View {
        TabView(selection: $selectedIndex) {
            
            FeedView()
                .onAppear(){
                    selectedIndex = 0
                }
                .tabItem{
                    Image(systemName: "house")
                }.tag(0)
            
            PublishView(tabIndex: $selectedIndex)
                .onAppear(){
                    selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "camera.shutter.button.fill")
                }.tag(1)
            
            SettingsView()
                .onAppear(){
                    selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "gear")
                }.tag(2)
            
            AccountView()
                .onAppear(){
                    selectedIndex = 3
                }
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }.tag(3)
            
            
        }
        .accentColor(.black)
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
