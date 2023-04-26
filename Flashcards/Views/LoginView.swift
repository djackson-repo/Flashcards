//
//  ContentView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI

class UserData: ObservableObject {
    @Published public var isAuthenticated = false
    @Published public var UserId = 0
}

struct LoginView: View {
    @State private var username = ""
     @State private var password = ""
     @StateObject private var user = UserData()
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
                                user.isAuthenticated = true
                            }
                            
                        }
                        .padding()
                        
                if user.isAuthenticated {
                    NavigationLink(destination: DecksView(username: $username, isAuthenticated: $user.isAuthenticated).navigationBarBackButtonHidden(), isActive: $user.isAuthenticated ) {
                                EmptyView()
                            }
                        }
                    }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
