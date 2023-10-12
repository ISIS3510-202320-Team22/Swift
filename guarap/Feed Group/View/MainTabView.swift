//
//  MainTabView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import SwiftUI

struct MainTabView: View {
    let user: User
    var body: some View {
        TabView {
            
            FeedView()
                .tabItem{
                    Image(systemName: "house")
                }
            
            PublishView()
                .tabItem {
                    Image(systemName: "camera.shutter.button.fill")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
            
            AccountView(user: user)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }
            
            
        }
        .accentColor(.black)
        Spacer()
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(user: User.MOCK_USERS[0])
    
    }
}
