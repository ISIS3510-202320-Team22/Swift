//
//  BugReportView.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 15-11-2023.
//

import SwiftUI

struct BugReportView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var isDescriptionSet = false
    
    @State private var showSuccessBanner = false
    @State private var showFailureBanner = false
    @State private var showNoInternetBanner = false
    
    @State private var isBlockingUI = false
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    var body: some View {
        
        ZStack {
            Form {
                Section(header: Text("Bug Title")) {
                    TextField("Title", text: $title)
                        .onSubmit {
                            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                }
                
                Section(header: Text("Description of the bug")) {
                    TextField("Description", text: $description)
                        .frame(height: 200) // Set the desired height
                        .cornerRadius(8)
                        .padding(.vertical, 8)
                        .onChange(of: description) { newValue in
                            if newValue.count > MAX_DESCRIPTION_CHAR_LIMIT {
                                description = String(newValue.prefix(MAX_DESCRIPTION_CHAR_LIMIT))
                            }
                        }
                        .onSubmit {
                            description = description.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                }
                
                Section {
                    Button(action: {
                        // Add your bug reporting logic here
                        self.submitBugReport()
                    }) {
                        Text("Submit Bug Report")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(guarapColor)
                    .cornerRadius(8)
                }
            }
            .navigationBarTitle("Report Bug")
            
        
            if isBlockingUI {
                Color.black.opacity(0.5) // Fondo oscuro detrás de la pantalla de carga
                ProgressView() // Pantalla de carga
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            
            if showSuccessBanner {
                BannerView(text: "Bug report uploaded.", color: .green)
            }
            
            if showFailureBanner {
                BannerView(text: "Failure uploading bug report\nCheck you filled both the title and description of the bug.", color: .red)
            }
            
            if showNoInternetBanner {
                BannerView(text: "Currently there is no internet connection.\nTry again later.", color: .yellow)
            }
        }
        .disabled(isBlockingUI)
    }
    
    func submitBugReport() {
        if !networkManager.isOnline {
            showNoInternetBanner = true
            hideBannerAfterDelay(3)
            return
        }
        else if title.isEmpty || description.isEmpty {
            showFailureBanner = true
            hideBannerAfterDelay(3)
            return
        }
        else {
            isBlockingUI = true
            GuarapRepositoryImpl.shared.sendBugReport(title: title, description: description) { result in
                if result {
                    showSuccessBanner = true
                    title = ""
                    description = ""
                } else {
                    showFailureBanner = true
                }
                
                hideBannerAfterDelay(3)
                
                isBlockingUI = false
            }
        }
        // You can add more actions, such as displaying an alert on successful submission
        // or navigating the user back to the previous screen.
    }
    
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showSuccessBanner = false
            showFailureBanner = false
            showNoInternetBanner = false
        }
    }
}

struct BugReportView_Previews: PreviewProvider {
    static var previews: some View {
        BugReportView()
    }
}
