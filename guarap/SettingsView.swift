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
    @State private var selectedLanguage = "English"
    
    var body: some View {
        NavigationView {
            Form {
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
                
                Section(header: Text("Language")) {
                    Picker("Select Language", selection: $selectedLanguage) {
                        Text("English").tag("English")
                        Text("Spanish").tag("Spanish")
                        Text("French").tag("French")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Account")) {
                    Button(action: {
                        // Handle account settings
                    }) {
                        Text("Manage Account")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .navigationBarItems(leading:
                NavigationLink(destination: Text("Previous Screen")) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
