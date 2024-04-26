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

    
    var totalMovie: Welcome?
    let netWorkingManager = NetworkingManager.shared
    
    var searchResults: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        

        let reservationNib = UINib(nibName: "SearchedMovieCell", bundle: nil)
        collectionView.register(reservationNib, forCellWithReuseIdentifier: "SearchedMovieCell")
        self.fetchMovieData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    
    
    
    func fetchMovieData() {
        netWorkingManager.fetchCombinedMovies { [weak self] result in
            switch result {
            case .success(let combinedData):
                let popularData = combinedData.popular
                let topRatedData = combinedData.topRated
                let upcomingData = combinedData.upcoming
                
                do {
                    let decoder = JSONDecoder()
                    
                    let popularWelcome = try decoder.decode(Welcome.self, from: popularData)
                    let topRatedWelcome = try decoder.decode(Welcome.self, from: topRatedData)
                    let upcomingWelcome = try decoder.decode(Welcome.self, from: upcomingData)
                    
                    var allMovies: [Movie] = []
                    allMovies.append(contentsOf: popularWelcome.results)
                    allMovies.append(contentsOf: topRatedWelcome.results)
                    allMovies.append(contentsOf: upcomingWelcome.results)
                    
                    let combinedWelcome = Welcome(results: allMovies)
                    
                    self?.totalMovie = combinedWelcome
                    self?.searchResults = allMovies
                    
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                } catch {
                    print("Error decoding movies: \(error)")
                }
                
            case .failure(let error):
                print("Error fetching combined movies: \(error)")
            }
        }
    }
    
    
    func fetchImage(for posterPath: String, completion: @escaping (UIImage?) -> Void) {
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w185/\(posterPath)")!
        
        URLSession.shared.dataTask(with: posterURL) { (data, response, error ) in
            guard let data = data, error == nil else {
                print("Failed to fetch image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to create image from data")
                completion(nil)
            }
        }.resume()
    }

    
}




extension MovieSecrchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SearchedMovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchedMovieCell", for: indexPath) as? SearchedMovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = searchResults[indexPath.item]
            cell.movieTitle.text = movie.title
        
        
        fetchImage(for: movie.posterPath) { image in
            DispatchQueue.main.async {
                cell.moviePoster.image = image
            }
        }
        return cell
    }
    
    // MARK: selected(컬렉션 뷰의 필터된 영화 포스터 클릭시, 영화 상세페이지로 이동)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)번 Cell 클릭")
    }
    
//    // MARK: cellSize
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let collectionViewWidth = collectionView.bounds.width
//        
//        // 셀의 너비를 설정합니다. 여기서는 컬렉션 뷰의 너비를 반으로 나누어 두 줄에 한 줄씩 표시합니다.
//        let cellWidth = (collectionViewWidth - 30) / 2 // 여기서 30은 셀 간의 간격과 섹션의 inset 값을 고려합니다.
//        
//        // 셀의 높이를 설정합니다. 여기서는 너비와 동일한 정사각형 모양으로 만듭니다.
//        let cellHeight = cellWidth
//        
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
//    
//    //MARK: margin in section
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//    
//    // MARK: minimumSpacing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }

}


extension MovieSecrchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResults = totalMovie?.results ?? []
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if totalMovie == nil {
        } else {
            print("totalMovie is not nil")
        }
        
        if let totalMovie = totalMovie {
            if searchText.isEmpty {
                searchResults = totalMovie.results
            } else {
                searchResults = totalMovie.results.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
            collectionView.reloadData()
        }
    }
}


