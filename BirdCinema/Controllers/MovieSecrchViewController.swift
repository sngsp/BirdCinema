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
        let voteCount: Int
    }
    
    struct Welcome: Codable {
        let results: [Movie]
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieData: Welcome?
    let netWorkingManager = NetworkingManager.shared
    
    var searchResults: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func fetchMovieData() {
        netWorkingManager.fetchCombinedMovies { [weak self] result in
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                do {
                    
                    let popularMovies = try decoder.decode(Welcome.self, from: data.popular)
                    
                    let topRatedMovies = try decoder.decode(Welcome.self, from: data.topRated)
                    
                    let upcomingMovies = try decoder.decode(Welcome.self, from: data.upcoming)
                    
                    let allMovies = (popularMovies.results + topRatedMovies.results + upcomingMovies.results)
                    
                    self?.searchResults = allMovies
                } catch {
                    print("Error decoding movie data: \(error)")
                }
            case .failure(let error):
                print("Error fetching movie data: \(error)")
            }
        }
    }
    
    
}

extension MovieSecrchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchMoiveCell", for: indexPath) as? SearchMovieCollectionViewCell else { fatalError("Failed to dequeue a cell") }
        
        let movie = searchResults[indexPath.item]
        cell.searchMovieMainLabel.text = movie.title
        
        let voteCount = movie.voteCount * 1000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        if let formattedVoteCount = formatter.string(from: NSNumber(value: voteCount)) {
            cell.searchMovieMainLabel.text = "\(formattedVoteCount)명"
        }
        
        cell.searchMovieButton.layer.borderWidth = 1
        cell.searchMovieButton.layer.borderColor = UIColor.systemIndigo.cgColor
        cell.searchMovieButton.layer.cornerRadius = 15
        
//        if let movie = searchResults?.results[indexPath.item] {
//            fetchImage(for: movie.posterPath) { image in
//                DispatchQueue.main.async {
//                    cell.searchMovieImage.image = image
//                }
//            }
//        }
        
        return cell
    }
    
    
}

