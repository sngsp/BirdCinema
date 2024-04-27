//
//  MovieDetailViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var screenTime: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var detailSummaryTextLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var blurredImageView: UIImageView!
    var heartButton = UIButton(type: .system)
    
    var movieData: Result?
    var posterPath: String?
    var isShowingFullSummary = false
    var isMovieInWishlist = false
    
    // Custom Struct 사용 시 작동
    var selectedMovieDataForStruct: SelectedMovieData? = SelectedMovieData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // Custom Struct 사용 시 작동
        updateUIForStruct()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

        // 기존 버튼이 존재하는지 확인하고, 존재하지 않는다면 추가
        if reservationButton.subviews.first(where: { $0 == heartButton }) == nil {
            reservationButton.addSubview(heartButton)
        }
        
    }
    
    // MARK: - UI 구성
    func configureUI() {
        view.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        movieNameLabel.textColor = .white
        reservationButton.backgroundColor = .systemIndigo
        reservationButton.tintColor = .white
        reservationButton.layer.cornerRadius = 22
        releaseYear.textColor = .lightGray
        screenTime.textColor = .lightGray
        summaryLabel.textColor = .white
        summaryLabel.text = "줄거리"
        detailSummaryTextLabel.numberOfLines = 3
        detailSummaryTextLabel.textColor = .white
        detailSummaryTextLabel.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        showMoreButton.tintColor = .systemIndigo
        showMoreButton.setTitle("> 더보기", for: .normal)
        moviePosterImageView.layer.cornerRadius = 10
        blurredImageView.layer.cornerRadius = 10
        self.navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
//     Custom Struct 사용 시 작동
    func updateUIForStruct() {
        guard let movieData = selectedMovieDataForStruct else { return }
        DispatchQueue.main.async {
            let randomScreenTime = Int.random(in: 150...180)
            self.screenTime.text = "\(randomScreenTime)분"
            self.movieNameLabel.text = movieData.movieTitle
            self.releaseYear.text = "\(movieData.movieReleaseDate)"
            if movieData.movieDetailSummary.isEmpty {
                self.detailSummaryTextLabel.text = "역사상 최강의 적! 더욱 강력해진 맹세! ‘삼총사’의 새로운 전설이 시작된다! 프랑스 왕의 친위부대 삼총사는 세계 최초 비행선을 설계한 다빈치의 설계도 암호를 갖고 베니스 총독 저택의 비밀 방에 모인다. 하지만 삼총사의 맏형 아토스의 연인 밀라디(밀라 요보비치)가 암호를 빼내, 악명 높은 버킹엄 공작(올랜도 블룸)에게 넘겨주며 삼총사는 임무를 실패하고마는데...!"
            } else {
                self.detailSummaryTextLabel.text = movieData.movieDetailSummary
            }
            self.posterPath = movieData.moviePoster
            
            guard let title = self.movieNameLabel.text, let date = self.releaseYear.text else {
                return
            }
            
            self.isMovieInWishlist = WishMovieManager.shared.wishlist.contains { $0.title == title && $0.date == date }
            self.configureCustomButton()
            print(self.isMovieInWishlist)
            
            if let posterPath = self.posterPath {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
                URLSession.shared.dataTask(with: posterURL) { [weak self] (data, response, error) in
                    guard let self = self, let data = data, error == nil else {
                        print("에러", error?.localizedDescription ?? "알 수 없는 에러")
                        return
                    }
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            // 흐림 효과 적용한 이미지
                            let blurredImage = image.applyBlurEffect()
                            self.moviePosterImageView.image = image
                            self.blurredImageView.image = blurredImage
                        } else {
                            print("이미지 변환 에러")
                        }
                    }
                }.resume()
            }
        }
    }
    
    @IBAction func showMoreButtonTapped(_ sender: UIButton) {
        if isShowingFullSummary {
            // 전체 내용을 보여주는 상태에서 버튼을 누르면 줄거리를 축약해서 보여줌
            UIView.animate(withDuration: 0.3, animations: {
                self.detailSummaryTextLabel.numberOfLines = 3
                self.view.layoutIfNeeded()
            }) { _ in
                // 애니메이션이 완료된 후에 버튼 타이틀 변경
                self.showMoreButton.setTitle("> 더보기", for: .normal)
            }
        } else {
            // 줄거리를 축약해서 보여주는 상태에서 버튼을 누르면 전체 내용을 보여줌
            UIView.animate(withDuration: 0.3, animations: {
                self.detailSummaryTextLabel.numberOfLines = 0
                self.view.layoutIfNeeded()
            }) { _ in
                // 애니메이션이 완료된 후에 버튼 타이틀 변경
                self.showMoreButton.setTitle("< 접기", for: .normal)
            }
        }
        // 상태 토글
        isShowingFullSummary.toggle()
    }
   
    // MARK: -  예매하기 버튼
    @IBAction func reservationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MovieReservation", bundle: nil)
        guard let movieReservationViewController = storyboard.instantiateViewController(withIdentifier: "MovieReservationViewController") as? MovieReservationViewController else { return }
        
        // 제목 전달
        movieReservationViewController.movieTitle = selectedMovieDataForStruct?.movieTitle
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(movieReservationViewController, animated: true)
        }
    }
    
    // MARK: - 찜하기 버튼
    func configureCustomButton() {
        if isMovieInWishlist {
            // 이미 찜한 영화
            heartButton.setTitle("♥", for: .normal)
            heartButton.tintColor = .red
        } else {
            heartButton.setTitle("♡", for: .normal)
            heartButton.tintColor = .white
        }
        
        heartButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        heartButton.frame = CGRect(x: 20, y: (reservationButton.frame.height - 20) / 2, width: 20, height: 20)
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
    }

    
    @objc func heartButtonTapped(_ sender: UIButton) {
        print("찜 버튼 클릭")
        guard let title = movieNameLabel.text, let date = releaseYear.text else {
            return
        }
        // 구조체에 데이터 저장
        let wishData = WishMovieData(title: title, date: date)
        if WishMovieManager.shared.wishlist.contains(where: { $0.title == title && $0.date == date }) {
            showAlert(title: "Notice", message: "이 영화는 이미 저장되어 있습니다.")
        } else {
            showConfirmationAlert(title: "Notice", message: "이 영화를 찜하시겠습니까?", wishData: wishData)
            sender.setTitle("♥", for: .normal)
            sender.tintColor = .red
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(title: String, message: String, wishData: WishMovieData) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "찜하기", style: .default, handler: { _ in
            WishMovieManager.shared.addMovieToWishlist(wishData)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
