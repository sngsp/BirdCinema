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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileIntro: UILabel!
    @IBOutlet weak var mainSearchBar: UISearchBar!
    @IBOutlet weak var mainPageImage: UIImageView!
    @IBOutlet weak var collectionViewHeaderLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
        configureUI()
    }
    
    func configureUI() {
        collectionViewHeaderLabel.text = "박스오피스"
    }
    
    func setupCollectionView() {
        let flowLayout = createFlowLayout()
        mainCollectionView.collectionViewLayout = flowLayout
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.alwaysBounceHorizontal = true
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
    
    
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
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
        return movieData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? MainCollectionViewCell else { fatalError("error")
        }
        
        if let movieData = movieData {
            let movie = movieData.results[indexPath.item]
            cell.collectionMainLabel.text = movie.title
            cell.collectionSubLabel.text = String(movie.voteCount)
        }
        
        return cell
        
    }
}
