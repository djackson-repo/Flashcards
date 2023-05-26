//
//  UserController.swift
//  Flashcards
//
//  Created by Dylan Jackson on 5/13/23.
//

import Foundation


enum UserError: Error {
    case invalidData
    case networkError
    case usernameUnavailable
    var errorDescription: String? {
        switch self {
        case .usernameUnavailable:
            return "Username is unavailable."
        default:
            return nil
        }
    }
}


class CustomURLSessionDelegate: NSObject, URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

class UserController {
    
    
    private let baseUrl = URL(string: "https://10.10.137.2:7089/api/user/")!
    private let customURLSessionDelegate = CustomURLSessionDelegate()
    private lazy var session = URLSession(configuration: .default, delegate: customURLSessionDelegate, delegateQueue: nil)
    
    func signInUser(username: String, password: String, completion: @escaping (Result<Void, UserError>) -> Void) {
        let user = UserModel(userId: 1, name: username, password: password)
        guard let data = try? JSONEncoder().encode(user) else {
            completion(.failure(.invalidData))
            return
        }
        var request = URLRequest(url: baseUrl.appendingPathComponent("post"))
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error signing in user: \(error.localizedDescription)")
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
    
    func getUserIdByUsername(username: String, completion: @escaping (Result<Int64, UserError>) -> Void) {

            let url = baseUrl.appendingPathComponent("getsingleuser/\(username)")

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
                        let fetchedUserId = try JSONDecoder().decode(Int64.self, from: data)
                        let theUserId: Int64 = fetchedUserId
                        print(theUserId)
                        completion(.success(theUserId))
                    } catch {
                        print("Error decoding user ID data: \(error)")
                        completion(.failure(.invalidData))
                    }
                }
            }
            task.resume()
        }
}
