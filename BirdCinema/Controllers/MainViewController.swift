//
//  ViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MainViewController: UIViewController {
    
    let netWorking = NetworkingManager.shared
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UILabel!
    
    @IBOutlet weak var mainSearchBar: UISearchBar!
    
    @IBOutlet weak var collectionViewLabel1: UILabel!
    @IBOutlet weak var collectionViewLabel2: UILabel!
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingManager.shared.fetchPopularMovies { result in
                switch result {
                case .success(let data):
                    
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Received data: \(jsonString)")
                    } else {
                        print("Failed to convert data to string.")
                    }
        
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(Welcome.self, from: data)
                        print("Parsed data: \(decodedData)")
                    } catch {
                        print("Failed to decode data: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Error fetching popular movies: \(error.localizedDescription)")
                }
            }
    }

    
    
    
    
    

}

