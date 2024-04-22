//
//  NetwrokingManager.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import Foundation
import Alamofire

class NetworkingManager {
    
    static let shared = NetworkingManager() // Singleton 인스턴스
    
    private let moiveURL = "https://api.themoviedb.org/3/movie/popular"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjVlZDdlZjAxOTM2NWI4ZjFiMWFkMjRjOTQ4NDkzOSIsInN1YiI6IjY2MjYwMTEwYWY5NTkwMDE3ZDZhMDBmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.F9AOBDGvoS2XnYPcxL6L2i4tw6n-27xbikaDh4YB_Qo"
    
    private init() {}
    
    
    func fetchPopularMovies(completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let parameters: Parameters = [
            "language": "ko-KR",
            "page": "1"
        ]
        
        AF.request(moiveURL, method: .get, parameters: parameters, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}




