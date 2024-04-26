//
//  MovieSecrchViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit
class MovieSecrchViewController: UIViewController {
    struct Movie:Codable {
        let title: String
        let posterPath: String
        enum CodingKeys: String, CodingKey {
            case title = "title"
            case posterPath = "poster_path"
        }
    }
    struct Welcome: Codable {
        let results: [Movie]
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
   
}

