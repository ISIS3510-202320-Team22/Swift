//
//  SettingsView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 28-09-2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    @AppStorage("notificationEnabled") private var notificationEnabled = true
    
    init() {
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            isDarkModeEnabled = true
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                        .onChange(of: isDarkModeEnabled) { newValue in
                            // Toggle Dark Mode based on the user's choice
                            if let windowScene = UIApplication.shared.connectedScenes
                                .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                                windowScene.windows.forEach { window in
                                    window.overrideUserInterfaceStyle = newValue ? .dark : .light
                                }
                            }
                        }
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationEnabled)
                }
                
                Section(header: Text("Information")) {
                    NavigationLink(destination: AboutUsView()) {
                        Text("About Us")
                    }
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: AccountView()) {
                        Text("Manage Account")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
