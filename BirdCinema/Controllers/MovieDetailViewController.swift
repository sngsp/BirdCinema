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
    
    var movieData: Result?
    var posterPath: String?
    var isShowingFullSummary = false
    
    // Custom Struct 사용 시 작동
    var selectedMovieDataForStruct: SelectedMovieData? = SelectedMovieData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // Custom Struct 사용 시 작동
         updateUIForStruct()
    }
    
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
        
//        moviePosterImageView.layer.cornerRadius = 20
//        moviePosterImageView.clipsToBounds = true
    }
    
//     Custom Struct 사용 시 작동
    func updateUIForStruct() {
        print(1)
        guard let movieData = selectedMovieDataForStruct else { return }
        print(2)
        DispatchQueue.main.async {
            print(3)
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
                self.detailSummaryTextLabel.numberOfLines = 10
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
    
}
