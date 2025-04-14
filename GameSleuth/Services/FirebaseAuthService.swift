//
//  FirebaseAuthService.swift
//  GameSleuth
//
//  Created by user273623 on 4/13/25.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService: ObservableObject {
    @Published var user: User?
    
    static let shared = FirebaseAuthService()
    
    private init() {
        // Listen for auth state changes.
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.user = user
            }
        }
    }
    
    // Registration
    func register(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Log the detailed error information
                    print("Registration Error: \(error.localizedDescription)")
                    print("Error Details: \(error)")
                    
                    if let authError = AuthErrorCode(rawValue: error._code) {
                        switch authError {
                        case .emailAlreadyInUse:
                            print("Error: The email is already in use.")
                        case .invalidEmail:
                            print("Error: The email address is badly formatted.")
                        case .weakPassword:
                            print("Error: The password must be at least 6 characters long.")
                        default:
                            print("Unhandled Firebase Auth error (code \(authError.rawValue)): \(authError.errorMessage)")
                        }
                    }
                } else {
                    // Registration successful, update the user property.
                    self.user = result?.user
                }
                completion(error)
            }
        }
    }
    
    // Login
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Log detailed login error information
                    print("Login Error: \(error.localizedDescription)")
                    print("Error Details: \(error)")
                    
                    if let authError = AuthErrorCode(rawValue: error._code) {
                        switch authError {
                        case .userNotFound:
                            print("Error: User not found.")
                        case .wrongPassword:
                            print("Error: Wrong password.")
                        case .invalidEmail:
                            print("Error: The email address is badly formatted.")
                        default:
                            print("Unhandled Firebase Auth error (code \(authError.rawValue)): \(authError.errorMessage)")
                        }
                    }
                } else {
                    self.user = result?.user
                }
                completion(error)
            }
        }
    }
    
    // Logout
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// Optional: Extend AuthErrorCode with custom error messages
extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "This email is already in use. Please try logging in."
        case .userNotFound:
            return "User not found. Please check the credentials."
        case .invalidEmail:
            return "The email address is badly formatted."
        case .weakPassword:
            return "The password must be at least 6 characters long."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        default:
            return "An unknown error occurred (code: \(self.rawValue))."
        }
    }
}
