//
//  ContentView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI

struct LoginView: View {
    @State private var user = UserModel(userId: -1, name: "", pass: "")
    @State private var isAuthenticated = false
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        NavigationView{
            VStack {
                TextField("Username", text: $username)
                .padding()
                        
                SecureField("Password", text: $password)
                .padding()
                        
                        Button("Login") {
                            // Replace these values with your own username and password
                            if username == "Djackson" && password == "password" {
                                isAuthenticated = true
                                user.name = username
                                user.pass = password
                            } else {
                                Text("Incorrect password")
                                                    .foregroundColor(.red)
                                                    
                            }
                            
                        }
                        .padding()
                        
                if isAuthenticated {
                    NavigationLink(destination: DecksView(user: $user, isAuthenticated: $isAuthenticated).navigationBarBackButtonHidden(), isActive: $isAuthenticated ) {
                                EmptyView()
                            }
                        }
                    }
        }
        
    }
}

