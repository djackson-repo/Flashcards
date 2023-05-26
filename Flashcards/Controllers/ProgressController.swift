//
//  ProgressController.swift
//  Flashcards
//
//  Created by Dylan Jackson on 5/17/23.
//

import Foundation

struct ProgressResponse: Codable {
    let progress: ProgressModel
}


enum ProgressError: Error {
    case invalidData
    case networkError
    case progressUnavailable
    var errorDescription: String? {
        switch self {
        case .progressUnavailable:
            return "Progress is unavailable."
        default:
            return nil
        }
    }
}

class ProgressController {
    private let baseUrl = URL(string: "https://10.10.137.2:7089/api/progress/")!
    private let customURLSessionDelegate = CustomURLSessionDelegate()
    private lazy var session = URLSession(configuration: .default, delegate: customURLSessionDelegate, delegateQueue: nil)
    
    func getProgressByUser(userId: Int64, completion: @escaping (Result<ProgressResponse, ProgressError>) -> Void) {

        let url = baseUrl.appendingPathComponent("getprogressbyuser/\(userId)")

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error getting user ID: \(error.localizedDescription)")
                completion(.failure(.networkError))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, let data = data {
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(.failure(.networkError))
                    return
                }
                do {
                    print(data)
                    let fetchedData = try JSONDecoder().decode(ProgressResponse.self, from: data)
                    completion(.success(fetchedData))
                } catch {
                    print("Error decoding user ID data: \(error)")
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }
    
    func PutProgress(progress: ProgressModel, completion: @escaping (Result<Void, CardError>) -> Void) {
        guard let data = try? JSONEncoder().encode(progress) else {
            completion(.failure(.invalidData))
            return
        }
        var request = URLRequest(url: baseUrl.appendingPathComponent("put"))
        request.httpMethod = "PUT"
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
