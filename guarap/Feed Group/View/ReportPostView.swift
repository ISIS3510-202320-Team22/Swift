import SwiftUI

struct PostReportView: View {
    @State private var description = ""
    @State private var isDescriptionSet = false
    
    @State private var showSuccessBanner = false
    @State private var showFailureBanner = false
    @State private var showNoInternetBanner = false
    @Binding var id_post: String
    @Binding var id_user_post: String

    @State private var isBlockingUI = false
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    var onReportSuccess: () -> Void
    var body: some View {
        NavigationStack{
            ZStack{
            ZStack {
                Form {
                    Section(header: Text("Description of the Issue")) {
                        TextField("Description", text: $description)
                            .frame(height: 200)
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
                            // Add your post reporting logic here
                            self.submitPostReport()
                        }) {
                            Text("Submit Report")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(guarapColor)
                        .cornerRadius(8)
                    }
                }
                .navigationBarTitle("Report Post")
            
                if isBlockingUI {
                    Color.black.opacity(0.5)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                }
                
                if showSuccessBanner {
                    BannerView(text: "Post report sent.", color: .green)
                }
                
                if showFailureBanner {
                    BannerView(text: "Failed to send report.\nMake sure to describe the issue.", color: .red)
                }
                
                if showNoInternetBanner {
                    BannerView(text: "No internet connection.\nTry again later.", color: .yellow)
                }
            }
            }
            .disabled(isBlockingUI)
        }
    }
    
    func submitPostReport() {
        print(id_post)
        print(id_user_post)
        if !networkManager.isOnline {
            showNoInternetBanner = true
            hideBannerAfterDelay(3)
            return
        }
        else if description.isEmpty {
            showFailureBanner = true
            hideBannerAfterDelay(3)
            return
        }
        else {
            isBlockingUI = true
            GuarapRepositoryImpl.shared.sendPostReport(description: description, id_post: id_post, id_user_post: id_user_post) { result in
         
                if result {
                    showSuccessBanner = true
                    description = ""
                    saveReportedPost(id: id_post)
                    onReportSuccess() // Llamamos al closure
                } else {
                    showFailureBanner = true
                }
                
                hideBannerAfterDelay(3)
                
                isBlockingUI = false
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


