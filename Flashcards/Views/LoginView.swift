//
//  ContentView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI

struct LoginView: View {
    @State private var user = UserModel(userId: -1, name: "", password: "")
    @State private var isAuthenticated: Bool? = false
    @State private var username = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var signInError: String?
    
    
    private let userController = UserController()
    var body: some View {
        NavigationView{
            VStack {
                TextField("Username", text: $user.name)
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                
                Button(action: signInUser) {
                    Text(isSigningIn ? "Signing In..." : "Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(isSigningIn)
                }
                .padding()
                .alert(isPresented: Binding<Bool>(get: { signInError != nil }, set: { _ in })) {
                    Alert(
                        title: signInError != nil ? Text("Sign In Failed") : Text("Sign In Successful"),
                        message: signInError != nil ? Text(signInError!) : Text("You have successfully signed in."),
                        dismissButton: .default(Text("OK")) {
                            signInError = nil
                        }
                    )
                }
                NavigationLink("", destination: DecksView(user: $user, isAuthenticated: $isAuthenticated).navigationBarBackButtonHidden(), tag: true, selection: $isAuthenticated)
            }
            
            .padding()
            
        }
        
    }
    private func signInUser() {
        self.isSigningIn = true
        user.password = "\(password)"
        userController.signInUser(username: user.name, password: user.password) { result in
            switch result {
            case .success:
                print("User signed in successfully")
                DispatchQueue.main.async {
                    userController.getUserIdByUsername(username: user.name) {result in
                        switch result {
                        case .success(let num):
                            user.userId = num
                        case .failure(let error):
                            print("Error signing in: \(error)")
                            self.signInError = error.localizedDescription
                        }
                    }
                    isAuthenticated = true
                }
            case .failure(let error):
                print("Error signing in: \(error)")
                self.signInError = error.localizedDescription
            }
            self.isSigningIn = false
        }
    }
}
