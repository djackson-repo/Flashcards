//
//  CardController.swift
//  Flashcards
//
//  Created by Dylan Jackson on 5/16/23.
//

import Foundation

struct CardResponse: Codable {
    let deck: CardModel
}

enum CardError: Error {
    case invalidData
    case networkError
    case deckUnavailable
    var errorDescription: String? {
        switch self {
        case .deckUnavailable:
            return "Deck is unavailable."
        default:
            return nil
        }
    }
}

class CardController {
    private let baseUrl = URL(string: "https://10.10.137.2:7089/api/cards/")!
    private let customURLSessionDelegate = CustomURLSessionDelegate()
    private lazy var session = URLSession(configuration: .default, delegate: customURLSessionDelegate, delegateQueue: nil)
    
    func GetCardByDeck(deckId: Int64, completion: @escaping (Result<[CardModel], CardError>) -> Void) {

        let url = baseUrl.appendingPathComponent("getcardsbydeck/\(deckId)")

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error getting user ID: \(error.localizedDescription)")
                completion(.failure(.networkError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.networkError))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let cardResponses = try JSONDecoder().decode([CardResponse].self, from: data)
                let cards = cardResponses.map { $0.deck }
                completion(.success(cards))
            } catch {
                print("Error decoding cards data: \(error)")
                completion(.failure(.invalidData))
            }

        }
        task.resume()
    }
    
    func PostCard(card: CardModel, completion: @escaping (Result<Void, CardError>) -> Void) {
        guard let data = try? JSONEncoder().encode(card) else {
            completion(.failure(.invalidData))
            return
        }
        var request = URLRequest(url: baseUrl.appendingPathComponent("post"))
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error posting card user: \(error.localizedDescription)")
                completion(.failure(.networkError))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Error response: \(responseString)")
                    }
                    print("Error signing in user: HTTP status code \(httpResponse.statusCode)")
                    completion(.failure(.networkError))
                    return
                }
                completion(.success(()))
            }
        }
        task.resume()
    }
}
