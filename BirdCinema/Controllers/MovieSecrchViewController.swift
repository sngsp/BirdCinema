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
        let releaseDate: String
        let overview: String
        
        enum CodingKeys: String, CodingKey {
            case title = "title"
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case overview = "overview"
        }
    }
    
    struct Welcome: Codable {
        let results: [Movie]
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var totalMovie: Welcome?
    let netWorkingManager = NetworkingManager.shared
    var selectedMovieDataForStruct: SelectedMovieData?
    
    var searchResults: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        let searchedNib = UINib(nibName: "SearchedMovieCell", bundle: nil)
        collectionView.register(searchedNib, forCellWithReuseIdentifier: "SearchedMovieCell")
        self.fetchMovieData()
        
        collectionView.collectionViewLayout = createCollectionViewFlowLayout(for: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 20
        searchBar.clipsToBounds = true
    }
    
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 170, height: 250)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
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
//            cell.movieTitle.text = movie.title
        
        
        fetchImage(for: movie.posterPath) { image in
            DispatchQueue.main.async {
                cell.moviePoster.image = image
                cell.moviePoster.layer.cornerRadius = 20
                cell.moviePoster.clipsToBounds = true
            }
        }
        return cell
    }
    
    // MARK: selected(컬렉션 뷰의 영화 포스터 클릭시, 영화 상세페이지로 이동)
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedMovieData = SelectedMovieData()
        
             let movie = searchResults[indexPath.item]
                selectedMovieData.moviePoster = movie.posterPath
                selectedMovieData.movieTitle = movie.title
                selectedMovieData.movieReleaseDate = movie.releaseDate
                selectedMovieData.movieDetailSummary = movie.overview
            
        
        selectedMovieDataForStruct = selectedMovieData
        
       
        
        // 화면 전환 및 영화 데이터 전달
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
    
        movieDetailViewController.selectedMovieDataForStruct = selectedMovieDataForStruct
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(movieDetailViewController, animated: true)
        }
    }
        

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
    
//    // MARK: selected(컬렉션 뷰의 필터링 된 영화 포스터 클릭시, 영화 상세페이지로 이동)
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var selectedMovieData = SelectedMovieData()
//
//        if collectionView == collectionView {
//            if let movie = totalMovie?.results[indexPath.item] {
//                selectedMovieData.moviePoster = movie.posterPath
//                selectedMovieData.movieTitle = movie.title
////                selectedMovieData.movieReleaseDate = movie.releaseDate
////                selectedMovieData.movieDetailSummary = movie.overview
//            }
//        }
//
//        selectedMovieDataForStruct = selectedMovieData
//
//        // 화면 전환 및 영화 데이터 전달
//        let storyboard = UIStoryboard(name: "MovieDetail", bundle: nil)
//        guard let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
//
//        movieDetailViewController.selectedMovieDataForStruct = selectedMovieDataForStruct
//
//        if let navigationController = self.navigationController {
//            navigationController.pushViewController(movieDetailViewController, animated: true)
//        }
//    }
//
}
