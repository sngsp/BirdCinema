//
//  NetwrokingManager.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import Foundation


class NetworkingManager {
    
    static let shared = NetworkingManager() // Singleton 인스턴스
    
    private let moiveURL = "https://api.themoviedb.org/3/movie/popular"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjVlZDdlZjAxOTM2NWI4ZjFiMWFkMjRjOTQ4NDkzOSIsInN1YiI6IjY2MjYwMTEwYWY5NTkwMDE3ZDZhMDBmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.F9AOBDGvoS2XnYPcxL6L2i4tw6n-27xbikaDh4YB_Qo"
    
    private init() {}
    
    
    func fetchPopularMovies(completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        guard let movieURL = URL(string: moiveURL) else {
            let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid movie URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: movieURL)
        request.httpMethod = "GET"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "page", value: "1")
        ]
        guard let url = components.url else {
            let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid movie URL"])
            completion(.failure(error))
            return
        }
        request.url = url
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "InvalidData", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    
    
    func fetchTopRatedMovies(completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        guard let movieURL2 = URL(string: "https://api.themoviedb.org/3/movie/top_rated") else {
            let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid movie URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: movieURL2)
        request.httpMethod = "GET"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        var components = URLComponents(url: movieURL2, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "page", value: "1")
        ]
        guard let url = components.url else {
            let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid movie URL"])
            completion(.failure(error))
            return
        }
        request.url = url
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "InvalidData", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

