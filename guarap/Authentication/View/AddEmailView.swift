//
//  AddEmailView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    @State private var emailExistsError = false
    @State private var isShowingAlert = false
    @State private var showAlertRepeat = false
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var isCompletingAction = false // Estado para mostrar la pantalla de carga
    
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
                    Text("Add your email")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    Text("You'll use this email to sign in to your account")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        .padding(.top)
                        .onChange(of: viewModel.email) { newValue in
                            
                            let allowedSymbols = CharacterSet(charactersIn: "!@#$%^&*()-+{}[]~_=\\/?<>.,:;\"\'`")
                            
                            viewModel.email = newValue.filter { !$0.isWhitespace }
                            
                            viewModel.email = String(viewModel.email.unicodeScalars.filter {
                                CharacterSet.alphanumerics.union(allowedSymbols).contains($0)
                            })
                            
                            
                            if newValue.count > MAX_EMAIL_CHAR_LIMIT {
                                viewModel.email = String(newValue.prefix(MAX_EMAIL_CHAR_LIMIT))
                            }
                        }
                    
                    NavigationLink(destination: CreateUsernameView(showing: $showNext), isActive: $showNext) {
                        Button(action: {
                            isCompletingAction = true
                            Task {
                                if await viewModel.emailExists(email: viewModel.email) {
                                    
                                    showAlertRepeat = true
                                    hideBannerAfterDelay(2)
                                    
                                    
                                } else if viewModel.email.count < MIN_EMAIL_CHAR_LIMIT {
                                    isShowingAlert = true
                                    hideBannerAfterDelay(2)
                                    
                                } else if !viewModel.email.hasSuffix("@uniandes.edu.co") {
                                    isShowingAlert = true
                                    hideBannerAfterDelay(2)
                                } else {
                                    showNext = true // Activate the NavigationLink
                                }
                                isCompletingAction = false
                            }
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
                    .disabled(isCompletingAction)
                }
                
                if isCompletingAction {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                
                
                
                
                if showAlertRepeat {
                    BannerView(text: "The email address you entered is already associated with an account.", color: .yellow)
                }
                if isShowingAlert {
                    BannerView(text: "Email is not correct and must end with '@uniandes.edu.co'.", color: .red)
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
            showAlertRepeat = false
            isShowingAlert = false
        }
    }
}

//struct AddEmailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEmailView(showing: .constant(true))
//    }
//}

