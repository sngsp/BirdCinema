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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "SearchedMovieCell", bundle: nil), forCellWithReuseIdentifier: "SearchedMovieCell")
        self.fetchMovieData()
    }
    
    func fetchMovieData() {
        netWorkingManager.fetchUpComingMovies { [weak self] result in
          switch result {
          case .success(let data):
            do {
              let decoder = JSONDecoder()
              let welcome = try decoder.decode(Welcome.self, from: data)
              self?.searchResults = welcome.results // 결과를 searchResults에 저장
              DispatchQueue.main.async {
                self?.collectionView.reloadData()
              }
            } catch {
              print("\(error)")
            }
          case .failure(let error):
            print("\(error)")
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
    
    // MARK: cellSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        _ = collectionView.bounds.width
        let _: CGFloat = 2
        let _: CGFloat = 1
        
        return CGSize(width: 180, height: 221)
    }
    
    //MARK: margin in section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: minimumSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}









