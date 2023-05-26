//
//  DeckCardView.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import SwiftUI

struct DeckCardFrontView: View {
    @Binding var isAuthenticated: Bool?
    @State var deckId: Int64
    @Binding var user: UserModel
    @State var cards: [CardModel] = []
    private let cardController = CardController()
    @State private var cardError: String?
    @State private var selectedCardId: String?
    
    @State private var isShowingPopup = false
    @State private var textField1 = ""
    @State private var textField2 = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Card View")
                    Button("Add Card") {
                                    isShowingPopup = true
                                }
                            }
                            .sheet(isPresented: $isShowingPopup, content: {
                                PopUpDeck(textField1: $textField1, textField2: $textField2, isShowingPopup: $isShowingPopup, deckId: deckId)
                            })
                
                List(cards, id: \.cardId) { card in
                    NavigationLink(
                        destination: DeckCardBackView(
                            isAuthenticated: $isAuthenticated,
                            backside: card.back
                        ),
                        tag: card.back,
                        selection: $selectedCardId
                    ) {
                        Text(card.front)
                    }
                }
                .navigationBarItems(
                    leading: Text("\(user.name)"),
                    trailing: NavView(
                        isAuthenticated: $isAuthenticated,
                        user: $user
                    )
                )
                .onAppear(perform: getCards)
            }
        }
    }
    
    func getCards() {
        cardController.GetCardByDeck(deckId: deckId) { result in
            switch result {
            case .success(let cardResult):
                self.cards = cardResult
            case .failure(let error):
                print("Error getting decks: \(error)")
                self.cardError = error.localizedDescription
            }
        }
    }
}

struct PopUpDeck: View {
    @Binding var textField1: String
    @Binding var textField2: String
    @Binding var isShowingPopup: Bool
    @State var deckId: Int64
    @State var newCard: CardModel = CardModel(cardId: -1, deckId: -1, front: "", back: "", timesStudied: 0)

     let cardController: CardController = CardController()
    @State private var cardError: String?
    
    var body: some View {
        VStack {
            TextField("Front Text", text: $textField1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Back Text", text: $textField2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Confirm") {
                isShowingPopup = false
                newCard.deckId = deckId
                newCard.front = textField1
                newCard.back = textField2
                PostCard()
                
                
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
    
    private func PostCard() {
        cardController.PostCard(card: newCard) { result in
            switch result {
            case .success:
                print("User signed in successfully")
                DispatchQueue.main.async {
                }
            case .failure(let error):
                print("Error signing in: \(error)")
                self.cardError = error.localizedDescription
            }
        }
    }
}


