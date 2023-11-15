//
//  CreateUsernameView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    @State private var isShowingAlert = false
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var isCompletingAction = false // Estado para la pantalla de carga
    @State private var showNoInternetBanner = false

    @Binding var showing: Bool
    @State var showNext = false
    
    @AppStorage("creatingProfile") var creatingProfile = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
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
                    Text ("Create a password")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight (.bold)
                        .padding (.top)
                    Text("You'll use this password to sign in to your account. Your password should have at least 7 characters.")
                        .font (.footnote)
                        .foregroundColor (.gray)
                        .multilineTextAlignment (.center)
                        .padding (.horizontal, 24)
                    SecureField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .font (.subheadline)
                        .padding (12)
                        .background (Color(.systemGray6))
                        .cornerRadius (10)
                        .padding (.horizontal, 24)
                        .padding (.top)
                        .onChange(of: viewModel.password) { newValue in
                            
                            let allowedSymbols = CharacterSet(charactersIn: "!@#$%^&*()-+{}[]~_=\\/?<>.,:;\"\'`")
                            
                            viewModel.password = newValue.filter { !$0.isWhitespace }
                            
                            viewModel.password = String(viewModel.password.unicodeScalars.filter {
                                CharacterSet.alphanumerics.union(allowedSymbols).contains($0)
                            })
                            
                            if newValue.count > MAX_PASSWORD_CHAR_LIMIT {
                                viewModel.password = String(newValue.prefix(MAX_PASSWORD_CHAR_LIMIT))
                            }
                        }
                    
                    NavigationLink(destination: CompleteSignUpView(showing: $showNext), isActive: $showNext) {
                        Button(action: {
                            isCompletingAction = true // Mostrar la pantalla de carga
                            Task {
                                do {
                                    if networkManager.isOnline {
                                        
                                        if viewModel.password.count < MIN_PASSWORD_CHAR_LIMIT {
                                            isShowingAlert = true
                                            hideBannerAfterDelay(2)
                                            
                                        } else {
                                            showNext = true // Activate the NavigationLink
                                        }
                                        
                                    }else {
                                        showNoInternetBanner = true
                                        hideBannerAfterDelay(2)
                                    }
                                }
                            }
                            
                            isCompletingAction = false // Ocultar la pantalla de carga
                            
                        }) {
                            Text("Next")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 360, height: 44)
                                .background(guarapColor)
                                .cornerRadius(8)
                        }
                        .padding(.vertical)
                    }
                    //.opacity(0) // Hide the navigation link
                    .disabled(isCompletingAction)
                }

                if isCompletingAction {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                if showNoInternetBanner {
                    BannerView(text: "Currently there is no internet connection.\nTry again later.", color: .yellow)
                }
                
                if isShowingAlert {
                    BannerView(text: "Password must have at least \(MIN_PASSWORD_CHAR_LIMIT) characters.", color: .red)
                }
            }
        }
        .onChange(of: showNext) { result in
            if !creatingProfile {
                showing = result
            }
        }
    }
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            isShowingAlert = false
        }
    }
}
//
//struct CreatePasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatePasswordView(showing: .constant(true))
//    }
//}
