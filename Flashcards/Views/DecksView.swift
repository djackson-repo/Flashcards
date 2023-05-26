//
//  DecksView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI


struct DecksView: View {
    @Binding var user: UserModel
    @Binding var isAuthenticated: Bool?
    @State private var decks: [DeckModel] = []
    @State private var deckError: String?
    private let deckController = DeckController()
    @State private var selectedDeckId: Int64?
    
    @State private var isShowingPopup = false
    @State private var textField1 = ""
    @State private var textField2 = ""
    @State private var selectedOption = ""
    
    let dropdownOptions = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Text("Deck View")
                    Button("Add Deck") {
                                    isShowingPopup = true
                                }
                            }
                            .sheet(isPresented: $isShowingPopup, content: {
                                PopupView(textField1: $textField1, textField2: $textField2, selectedOption: $selectedOption, isShowingPopup: $isShowingPopup, userId: user.userId, dropdownOptions: dropdownOptions)
                            })
                List(decks, id: \.deckId) { deck in
                    NavigationLink(
                        destination: DeckCardFrontView(
                            isAuthenticated: $isAuthenticated,
                            deckId: deck.deckId,
                            user: $user
                        ),
                        tag: deck.deckId,
                        selection: $selectedDeckId
                    ) {
                        Text(deck.name)
                    }
                }
                .navigationBarItems(
                    leading: Text("\(user.name)"),
                    trailing: NavView(
                        isAuthenticated: $isAuthenticated,
                        user: $user
                    )
                )
                .onAppear(perform: getDecks)
            }
        }
    }
    
    func getDecks() {
        deckController.GetDeckByUser(userId: user.userId) { result in
            switch result {
            case .success(let deckResult):
                self.decks = deckResult
            case .failure(let error):
                print("Error getting decks: \(error)")
                self.deckError = error.localizedDescription
            }
        }
    }
}


struct NavView: View {
    @Binding var isAuthenticated: Bool?
    @Binding var user : UserModel
    
    var body: some View {
        HStack {
            Button("Logout") {
                isAuthenticated = false
            }
            .foregroundColor(.red)
            .font(.headline)
            
            NavigationLink(
                destination: ProfileView(user: $user, isAuthenticated: $isAuthenticated)
            ) {
                Text("Profile")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct PopupView: View {
    @Binding var textField1: String
    @Binding var textField2: String
    @Binding var selectedOption: String
    @Binding var isShowingPopup: Bool
    @State var userId: Int64
    @State var newDeck: DeckModel = DeckModel(deckId: 0, name: "", description: "", userId: 0, tagId: 1)
    let dropdownOptions: [String]
    let deckController: DeckController = DeckController()
    @State private var deckError: String?
    var body: some View {
        VStack {
            TextField("Enter Text 1", text: $textField1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter Text 2", text: $textField2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("Select Option", selection: $selectedOption) {
                ForEach(dropdownOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Button("Confirm") {
                isShowingPopup = false
                newDeck.name = textField1
                newDeck.description = textField2
                newDeck.userId = userId
                PostDeck()
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
    
    
    private func PostDeck() {
        deckController.PostDeck(deck: newDeck) { result in
            switch result {
            case .success:
                print("User signed in successfully")
                DispatchQueue.main.async {
                }
            case .failure(let error):
                print("Error signing in: \(error)")
                self.deckError = error.localizedDescription
            }
        }
    }
}

