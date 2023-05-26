//
//  DecksController.swift
//  Flashcards
//
//  Created by Dylan Jackson on 5/15/23.
//

import Foundation

struct DeckResponse: Codable {
    let deck: DeckModel
}



enum DeckError: Error {
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

class DeckController {
    private let baseUrl = URL(string: "https://10.10.137.2:7089/api/deck/")!
    private let customURLSessionDelegate = CustomURLSessionDelegate()
    private lazy var session = URLSession(configuration: .default, delegate: customURLSessionDelegate, delegateQueue: nil)
    
    func GetDeckByUser(userId: Int64, completion: @escaping (Result<[DeckModel], DeckError>) -> Void) {

        let url = baseUrl.appendingPathComponent("getdecksbyuser/\(userId)")

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
                let decks = try JSONDecoder().decode([DeckResponse].self, from: data).map { $0.deck }
                    completion(.success(decks))
            } catch {
                print("Error decoding decks data: \(error)")
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func PostDeck(deck: DeckModel, completion: @escaping (Result<Void, CardError>) -> Void) {
        guard let data = try? JSONEncoder().encode(deck) else {
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
