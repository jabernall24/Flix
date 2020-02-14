//
//  TheMoviewDBAPI.swift
//  Flix
//
//  Created by Jesus Andres Bernal Lopez on 11/25/19.
//  Copyright © 2019 Jesus Bernal Lopez. All rights reserved.
//

import Foundation

class TheMovieDBAPI {
    
    static let shared = TheMovieDBAPI()
    
    private init() {}

    private let baseURLString = "https://api.themoviedb.org/3/"
    private let apiKey = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    func nowPlaying(page: Int, completion: @escaping(Result<[Movie], FlixError>) -> ()) {
        guard let url = URL(string: "\(baseURLString)movie/now_playing?\(apiKey)&page=\(page)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.invalidResponse))
            } else if let data = data {
                do {
                    guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(.failure(.invalidData))
                        return
                    }
                    guard let result = dataDictionary["results"] as? [[String: Any]] else {
                        completion(.failure(.invalidData))
                        return
                    }
                    
                    let resultData = try JSONSerialization.data(withJSONObject: result, options: [])
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movies = try decoder.decode([Movie].self, from: resultData)
                    
                    completion(.success(movies))
                } catch {
                    completion(.failure(.invalidData))
                }
            }

        }
        task.resume()
    }
    
    func nowPlayingSimilar(for movieId: Int, page: Int, completion: @escaping (Result<[Movie], FlixError>) -> ()) {
        guard let url = URL(string: "\(baseURLString)movie/\(movieId)/similar?\(apiKey)&page=\(page)") else {
            completion(.failure(.invalidUrl))
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.invalidResponse))
            } else if let data = data {
                do {
                    guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(.failure(.invalidData))
                        return
                    }
                    guard let result = dataDictionary["results"] as? [[String: Any]] else {
                        completion(.failure(.invalidData))
                        return
                    }
                    
                    let resultData = try JSONSerialization.data(withJSONObject: result, options: [])
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let movies = try decoder.decode([Movie].self, from: resultData)
                    
                    completion(.success(movies))
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }

    func getReviewsFor(movie movieId: Int, page: Int, completion: @escaping (Result<[Review], FlixError>) -> ()) {
        guard let url = URL(string: "\(baseURLString)movie/\(movieId)/reviews?\(apiKey)&page=\(page)") else {
            completion(.failure(.invalidUrl))
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.invalidResponse))
            } else if let data = data {
                do {
                    guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        completion(.failure(.invalidData))
                        return
                    }
                    guard let result = dataDictionary["results"] as? [[String: Any]] else {
                        completion(.failure(.invalidData))
                        return
                    }
                    
                    let resultData = try JSONSerialization.data(withJSONObject: result, options: [])
                    
                    let reviews = try JSONDecoder().decode([Review].self, from: resultData)
                    
                    completion(.success(reviews))
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }

}
