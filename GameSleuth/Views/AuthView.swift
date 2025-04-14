//
//  AuthView.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//


import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var errorMessage: String?
    @ObservedObject var authService = FirebaseAuthService.shared

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(isRegistering ? "Register" : "Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isRegistering)

                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .shadow(radius: 5)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 30)
                        .transition(.slide)
                        .animation(.easeInOut, value: errorMessage)
                }

                Button(action: {
                    if isRegistering {
                        authService.register(email: email, password: password) { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                errorMessage = nil
                            }
                        }
                    } else {
                        authService.login(email: email, password: password) { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                errorMessage = nil
                            }
                        }
                    }
                }) {
                    Text(isRegistering ? "Sign Up" : "Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                .padding(.horizontal, 30)

                Button(action: {
                    withAnimation {
                        isRegistering.toggle()
                    }
                }) {
                    Text(isRegistering ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .underline()
                }
                
                Spacer()
            }
            .padding(.top, 100)
        }
    }
}
