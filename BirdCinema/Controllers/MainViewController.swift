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
    var upComingMovieData: Welcome?
    var imageData: Result?
    var selectedMovieDataForStruct: SelectedMovieData?
    
    // 셀을 생성할 때 사용할 클로저 정의
    var cellConfiguration: ((MainCollectionViewCell) -> Void)?
    
    @IBOutlet weak var mainPageImage: UIImageView!
    @IBOutlet weak var collectionViewHeaderLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var subCollectionView: UICollectionView!
    @IBOutlet weak var subcollectionViewHeaderLabel: UILabel!
    @IBOutlet weak var upComingCollectionView: UICollectionView!
    @IBOutlet weak var upComingCollectionViewHeaderLabel: UILabel!
    
    @IBOutlet weak var technologyImage1: UIImageView!
    @IBOutlet weak var technologyImage2: UIImageView!
    @IBOutlet weak var technologyImage3: UIImageView!
    
    @IBOutlet weak var bottomLogoImage: UIImageView!
    
    
    
    private var currentIndex = 0
    private let images = ["HomeImage", "HomeImage2", "HomeImage4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
        fetchSecondaryData()
        fetchUpcomingData()
        configureUI()
        setupTimer()
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = .systemIndigo
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
    func configureUI() {
        collectionViewHeaderLabel.text = "박스오피스"
        subcollectionViewHeaderLabel.text = "가장 많이 본 영화"
        upComingCollectionViewHeaderLabel.text = "개봉 예정 영화"
        
        mainPageImage.image = UIImage(named: images[currentIndex])
        technologyImage1.image = UIImage(named: "TechImage")
        technologyImage2.image = UIImage(named: "TechImage2")
        technologyImage3.image = UIImage(named: "TechImage3")
        
        technologyImage1.layer.cornerRadius = 20
        technologyImage1.layer.masksToBounds = true

        technologyImage2.layer.cornerRadius = 20
        technologyImage2.layer.masksToBounds = true

        technologyImage3.layer.cornerRadius = 20
        technologyImage3.layer.masksToBounds = true
        
        bottomLogoImage.image = UIImage(named: "BirdCinemaLogo2")
        
        
    }
    
    func setupCollectionView() {
        mainCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: mainCollectionView)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.alwaysBounceHorizontal = true
        
        subCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: subCollectionView)
        subCollectionView.delegate = self
        subCollectionView.dataSource = self
        subCollectionView.alwaysBounceHorizontal = true
        
        upComingCollectionView.collectionViewLayout = createCollectionViewFlowLayout(for: upComingCollectionView)
        upComingCollectionView.delegate = self
        upComingCollectionView.dataSource = self
        upComingCollectionView.alwaysBounceHorizontal = true
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
    
    func fetchUpcomingData() {
        netWorkingManager.fetchUpComingMovies { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self?.upComingMovieData = try decoder.decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        self?.upComingCollectionView.reloadData()
                    }
                } catch {
                    print("\(error)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
    func createCollectionViewFlowLayout(for collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 160, height: 350)
        return layout
    }
    
    
    @IBAction func mainPageController(_ sender: UIPageControl) {
        
    }
    
    @IBAction func movieRevervationButtonTapped(_ sender: UIButton) {
    }
}


extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return movieData?.results.count ?? 0
        } else if collectionView == subCollectionView {
            return secondaryMovieData?.results.count ?? 0
        } else if collectionView == upComingCollectionView {
            return upComingMovieData?.results.count ?? 0
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? MainCollectionViewCell else { fatalError("Failed to dequeue MainCollectionViewCell") }
            
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
                        cell.collectionMainImage.layer.cornerRadius = 20
                        cell.collectionMainImage.clipsToBounds = true
                    }
                }
            }
            
            // 셀에 클로저 전달
            cell.cellConfiguration = { cell in
                print("Main 예매하기 버튼 클릭")
                
                let storyboard = UIStoryboard(name: "MovieReservation", bundle: nil)
                guard let movieReservationViewController = storyboard.instantiateViewController(withIdentifier: "MovieReservationViewController") as? MovieReservationViewController else { return }
                
                movieReservationViewController.movieTitle = cell.collectionMainLabel.text
                
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(movieReservationViewController, animated: true)
                }
            }
            
            return cell
        } else if collectionView == subCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpRateViewCell", for: indexPath) as? UpRateCollectionViewCell else {
                fatalError("Failed to dequeue UpRateViewCell")
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
                        cell.upRateCollectionImage.layer.cornerRadius = 20
                        cell.upRateCollectionImage.clipsToBounds = true
                    }
                }
            }
            
            // 셀에 클로저 전달
            cell.cellConfiguration = { cell in
                print("UpRate 예매하기 버튼 클릭")
                
                let storyboard = UIStoryboard(name: "MovieReservation", bundle: nil)
                guard let movieReservationViewController = storyboard.instantiateViewController(withIdentifier: "MovieReservationViewController") as? MovieReservationViewController else { return }
                
                movieReservationViewController.movieTitle = cell.upRateCollectionMainLabel.text
                
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(movieReservationViewController, animated: true)
                }
            }
            
            return cell
            
        } else if collectionView == upComingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingCell", for: indexPath) as? UpComingCollectionViewCell else {
                fatalError("Failed to dequeue UpComingCell")
            }
            
            if let movieData = upComingMovieData {
                let movie = movieData.results[indexPath.item]
                cell.upComingMainLabel.text = movie.title
                
                let voteCount = movie.voteCount * 1000
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                if let formattedVoteCount = formatter.string(from: NSNumber(value: voteCount)) {
                    cell.upComingSubLabel.text = "\(formattedVoteCount)명"
                }
            }
            
            cell.upComingButton.layer.borderWidth = 1
            cell.upComingButton.layer.borderColor = UIColor.systemIndigo.cgColor
            cell.upComingButton.layer.cornerRadius = 15
            
            
            if let movie = upComingMovieData?.results[indexPath.item] {
                fetchImage(for: movie.posterPath) { image in
                    DispatchQueue.main.async {
                        cell.upComingImage.image = image
                        cell.upComingImage.layer.cornerRadius = 20
                        cell.upComingImage.clipsToBounds = true
                    }
                }
            }
            
            // 셀에 클로저 전달
            cell.cellConfiguration = { cell in
                print("Main 예매하기 버튼 클릭")
                
                let storyboard = UIStoryboard(name: "MovieReservation", bundle: nil)
                guard let movieReservationViewController = storyboard.instantiateViewController(withIdentifier: "MovieReservationViewController") as? MovieReservationViewController else { return }
                
                movieReservationViewController.movieTitle = cell.upComingMainLabel.text
                
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(movieReservationViewController, animated: true)
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedMovieData = SelectedMovieData()
        
        if collectionView == mainCollectionView {
            if let movie = movieData?.results[indexPath.item] {
                selectedMovieData.moviePoster = movie.posterPath
                selectedMovieData.movieTitle = movie.title
                selectedMovieData.movieReleaseDate = movie.releaseDate
                selectedMovieData.movieDetailSummary = movie.overview
            }
        } else if collectionView == subCollectionView {
            if let movie = secondaryMovieData?.results[indexPath.item] {
                selectedMovieData.moviePoster = movie.posterPath
                selectedMovieData.movieTitle = movie.title
                selectedMovieData.movieReleaseDate = movie.releaseDate
                selectedMovieData.movieDetailSummary = movie.overview
            }
        } else if collectionView == upComingCollectionView {
            if let movie = upComingMovieData?.results[indexPath.item] {
                selectedMovieData.moviePoster = movie.posterPath
                selectedMovieData.movieTitle = movie.title
                selectedMovieData.movieReleaseDate = movie.releaseDate
                selectedMovieData.movieDetailSummary = movie.overview
            }
        }
    
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


