//
//  ViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MainViewController: UIViewController {
    
    let netWorkingManager = NetworkingManager.shared
    var movieData: Welcome?
    var secondaryMovieData: Welcome?
    var imageData: Result?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UILabel!
    @IBOutlet weak var mainSearchBar: UISearchBar!
    @IBOutlet weak var mainPageImage: UIImageView!
    @IBOutlet weak var collectionViewHeaderLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    @IBOutlet weak var subcollectionViewHeaderLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    private var currentIndex = 0
    private let images = ["HomeImage", "HomeImage2", "HomeImage3", "HomeImage4"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
        fetchSecondaryData()
        configureUI()
        setupTimer()
    }
    
    
    
    
    func configureUI() {
        collectionViewHeaderLabel.text = "박스오피스"
        subcollectionViewHeaderLabel.text = "가장 많이 본 영화"
        mainPageImage.image = UIImage(named: images[currentIndex])
        
        
    }
    
    func setupCollectionView() {
        let flowLayout = createFirstCollectionViewFlowLayout()
        mainCollectionView.collectionViewLayout = flowLayout
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.alwaysBounceHorizontal = true
        
        let secondflowLayout = createSecondCollectionViewFlowLayout()
        subCollectionView.collectionViewLayout = secondflowLayout
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.alwaysBounceHorizontal = true
    }
    
    func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            self.currentIndex = (self.currentIndex + 1) % self.images.count
            UIView.transition(with: self.mainPageImage, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.mainPageImage.image = UIImage(named: self.images[self.currentIndex])
            }, completion: nil)
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
    
    
    func fetchData() {
        netWorkingManager.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self?.movieData = try decoder.decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        self?.mainCollectionView.reloadData()
                    }
                } catch {
                    print("\(error)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func fetchSecondaryData() {
        netWorkingManager.fetchTopRatedMovies { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self?.secondaryMovieData = try decoder.decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        self?.subCollectionView.reloadData()
                    }
                } catch {
                    print("\(error)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
        
    
    
    
    func createFirstCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        mainCollectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 200, height: 350)
        return layout
    }
    
    
    func createSecondCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        subCollectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 200, height: 350)
        return layout
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func mainPageController(_ sender: UIPageControl) {
    }
    
    @IBAction func movieRevervationButtonTapped(_ sender: UIButton) {
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return movieData?.results.count ?? 0
        } else if collectionView == subCollectionView {
            return secondaryMovieData?.results.count ?? 0
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
                fatalError("Failed to dequeue MainCollectionViewCell")
            }
            
            if let movieData = movieData {
                let movie = movieData.results[indexPath.item]
                cell.collectionMainLabel.text = movie.title
                
                let voteCount = movie.voteCount * 1000
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                if let formattedVoteCount = formatter.string(from: NSNumber(value: voteCount)) {
                    cell.collectionSubLabel.text = "\(formattedVoteCount)명"
                }
            }
            
            cell.collectionButton.layer.borderWidth = 1
            cell.collectionButton.layer.borderColor = UIColor.systemIndigo.cgColor
            cell.collectionButton.layer.cornerRadius = 15
            
            
            if let movie = movieData?.results[indexPath.item] {
                fetchImage(for: movie.posterPath) { image in
                    DispatchQueue.main.async {
                        cell.collectionMainImage.image = image
                    }
                }
            }
            
            return cell
        } else if collectionView == subCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpRateViewCell", for: indexPath) as? UpRateCollectionViewCell else {
                fatalError("Failed to dequeue SubCollectionViewCell")
            }
            
            if let movieData = secondaryMovieData {
                let movie = movieData.results[indexPath.item]
                cell.upRateCollectionMainLabel.text = movie.title
                
                let voteCount = movie.voteCount * 1000
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                if let formattedVoteCount = formatter.string(from: NSNumber(value: voteCount)) {
                    cell.upRateCollectionSubLabel.text = "\(formattedVoteCount)명"
                }
            }
            
            cell.upRateButton.layer.borderWidth = 1
            cell.upRateButton.layer.borderColor = UIColor.systemIndigo.cgColor
            cell.upRateButton.layer.cornerRadius = 15
            
            
            if let movie = secondaryMovieData?.results[indexPath.item] {
                fetchImage(for: movie.posterPath) { image in
                    DispatchQueue.main.async {
                        cell.upRateCollectionImage.image = image
                    }
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    

}


