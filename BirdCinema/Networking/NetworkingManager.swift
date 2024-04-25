//
//  NetwrokingManager.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import Foundation


class NetworkingManager {
    
    static let shared = NetworkingManager()
    
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
    
    func fetchUpComingMovies(completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        guard let movieURL3 = URL(string: "https://api.themoviedb.org/3/movie/upcoming") else {
            let error = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid movie URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: movieURL3)
        request.httpMethod = "GET"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        var components = URLComponents(url: movieURL3, resolvingAgainstBaseURL: true)!
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
    
    // 세개의 데이터를 모두 한곳에 합친 함수
    func fetchCombinedMovies(completion: @escaping (Swift.Result<(popular: Data, topRated: Data, upcoming: Data), Error>) -> Void) {
        let dispatchGroup = DispatchGroup()

        var popularMoviesData: Data?
        var topRatedMoviesData: Data?
        var upcomingMoviesData: Data?
        var error: Error?

        // Fetch popular movies
        dispatchGroup.enter()
        fetchPopularMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                popularMoviesData = data
            case .failure(let err):
                error = err
            }
        }

        // Fetch top rated movies
        dispatchGroup.enter()
        fetchTopRatedMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                topRatedMoviesData = data
            case .failure(let err):
                error = err
            }
        }

        // Fetch upcoming movies
        dispatchGroup.enter()
        fetchUpComingMovies { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                upcomingMoviesData = data
            case .failure(let err):
                error = err
            }
        }

        // Notify when all requests are completed
        dispatchGroup.notify(queue: .main) {
            if let error = error {
                completion(.failure(error))
            } else if let popularData = popularMoviesData, let topRatedData = topRatedMoviesData, let upcomingData = upcomingMoviesData {
                completion(.success((popular: popularData, topRated: topRatedData, upcoming: upcomingData)))
            }
        }
    }
    
    
}

