//
//  TheMoviewDBAPI.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 11/25/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import Foundation

class TheMovieDBAPI {
    
    static private let baseURLString = "https://api.themoviedb.org/3/"
    static private let apiKey = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    static func nowPlaying(completion: @escaping(Result<[[String: Any]], Error>) -> ()) {
        guard let url = URL(string: baseURLString + "movie/now_playing?" + apiKey) else { return }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(.failure(TheMovieDBAPIError(.invalidConvertionFromDataToJson)))
                        return
                    }
                    guard let result = dataDictionary["results"] as? [[String: Any]] else {
                        completion(.failure(TheMovieDBAPIError(.fieldNotFound)))
                        return
                    }
                    
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }

        }
        task.resume()
    }
    
    static func nowPlayingSimilar(completion: @escaping (Result<[[String: Any]], Error>) -> ()) {
        let url = URL(string: baseURLString + "movie/324857/similar?\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(.failure(TheMovieDBAPIError(.invalidConvertionFromDataToJson)))
                        return
                    }
                    guard let result = dataDictionary["results"] as? [[String: Any]] else {
                        completion(.failure(TheMovieDBAPIError(.fieldNotFound)))
                        return
                    }
                    
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}


class TheMovieDBAPIError: NSObject, LocalizedError {
    var desc = ""
    init(_ option: options) {
        desc = option.rawValue
    }
    
    override var description: String {
        get {
            return "Error: \(desc)"
        }
    }
    
    var errorDescription: String? {
        get {
            return self.description
        }
    }
    
    enum options: String {
        case invalidConvertionFromDataToJson = "Attempted to convert data to json"
        case fieldNotFound = "Attempted to get a field in dictionary that is not present"
    }
}

