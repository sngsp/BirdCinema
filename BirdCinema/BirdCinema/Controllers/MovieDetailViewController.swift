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
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var detailSummaryTextLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var blurredImageView: UIImageView!
    
    var movieData: Result?
    var posterPath: String?
    var isShowingFullSummary = false
    
    // Custom Struct 사용 시 작동
//    var selectedMovieDataForStruct: SelectedMovieData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // random API 호출 시 작동
        fetchRandomMovie()
        
        // Custom Struct 사용 시 작동
//         updateUIForStruct()
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        movieNameLabel.textColor = .white
        reservationButton.backgroundColor = .systemIndigo
        reservationButton.tintColor = .white
        reservationButton.layer.cornerRadius = 22
        releaseYear.textColor = .lightGray
        screenTime.textColor = .lightGray
        genreLabel.textColor = .lightGray
        summaryLabel.textColor = .white
        summaryLabel.text = "줄거리"
        detailSummaryTextLabel.numberOfLines = 3
        detailSummaryTextLabel.textColor = .white
        detailSummaryTextLabel.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        showMoreButton.tintColor = .systemIndigo
        showMoreButton.setTitle("더보기", for: .normal)
        
    }
    
    func fetchRandomMovie() {
        NetworkingManager.shared.fetchPopularMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let movieResponse = try decoder.decode(Welcome.self, from: data)
                    if let randomMovie = movieResponse.results.randomElement() {
                        DispatchQueue.main.async {
                            self.movieData = randomMovie
                            self.updateUI()
                        }
                    }
                } catch {
                    print("에러 : \(error)")
                }
            case .failure(let error):
                print("Fetching 오류 : \(error)")
            }
        }
    }
    
    func updateUI() {
        guard let movie = movieData else { return }
               DispatchQueue.main.async {
                   self.movieNameLabel.text = movie.title
                   self.releaseYear.text = "\(movie.releaseDate)"
                   // API에서 직접 제공되지 않아서 예시값
                   self.screenTime.text = "123분"
                   // API에서 직접 제공되지 않아서 예시값
                   self.genreLabel.text = "액션"
                   if movie.overview.isEmpty {
                       self.detailSummaryTextLabel.text = "역사상 최강의 적! 더욱 강력해진 맹세! ‘삼총사’의 새로운 전설이 시작된다! 프랑스 왕의 친위부대 삼총사는 세계 최초 비행선을 설계한 다빈치의 설계도 암호를 갖고 베니스 총독 저택의 비밀 방에 모인다. 하지만 삼총사의 맏형 아토스의 연인 밀라디(밀라 요보비치)가 암호를 빼내, 악명 높은 버킹엄 공작(올랜도 블룸)에게 넘겨주며 삼총사는 임무를 실패하고 다빈치의 설계도는 버킹엄 공작 손에 들어간다. 일년 후, 프랑스의 실질적인 권력을 휘두르는 추기경(크리스토프 왈츠)은 꼭두각시 왕을 제거하고 왕권을 차지하기 위해, 대규모 군사력을 자랑하는 버킹엄 공작과 미모의 스파이 밀라디를 동원해 거대한 음모를 계획한다. 한편 왕의 친위부대가 되기 위해 성으로 향하던 달타냥(로건 레먼)은 우연히 만난 삼총사와 합류하게 되고, 추기경의 음모를 알아챈 왕비로부터 음모를 제지하라는 임무를 받게 된다. 지시에 따라 떠난 영국에서 그들은 거대한 음모의 실체와 마주하게 되고, 프랑스 왕실의 운명을 건 절체절명의 대결을 벌이게 되는데…!"
                   } else {
                       self.detailSummaryTextLabel.text = movie.overview
                   }
                   self.posterPath = movie.posterPath
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
    
    // Custom Struct 사용 시 작동
//    func updateUIForStruct() {
//        guard let movieData = selectedMovieDataForStruct else { return }
//        
//        DispatchQueue.main.async {
//            self.movieNameLabel.text = movieData.movieTitle
//            self.releaseYear.text = movieData.movieReleaseDate
//            self.detailSummaryTextLabel.text = movieData.movieDetailSummary
//            
//            self.posterPath = movieData.moviePoster
//            if let posterPath = self.posterPath {
//                let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
//                URLSession.shared.dataTask(with: posterURL) { (data, response, error) in
//                    guard let data = data, error == nil else {
//                        print("에러", error?.localizedDescription ?? "알 수 없는 에러")
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        if let image = UIImage(data: data) {
//                            self.moviePosterImageView.image = image
//                        } else {
//                            print("이미지 변환 에러")
//                        }
//                    }
//                }.resume()
//            }
//        }
//    }
    
    @IBAction func showMoreButtonTapped(_ sender: UIButton) {
        if isShowingFullSummary {
            // 전체 내용을 보여주는 상태에서 버튼을 누르면 줄거리를 축약해서 보여줌
            detailSummaryTextLabel.numberOfLines = 3
            showMoreButton.setTitle("더보기", for: .normal)
        } else {
            // 줄거리를 축약해서 보여주는 상태에서 버튼을 누르면 전체 내용을 보여줌
            detailSummaryTextLabel.numberOfLines = 0
            showMoreButton.setTitle("접기", for: .normal)
        }
        // 상태 토글
        isShowingFullSummary.toggle()
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    func applyBlurEffect() -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        let beginImage = CIImage(image: self)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(30, forKey: kCIInputRadiusKey)

        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return nil }

        let processedImage = UIImage(cgImage: cgimg)
        return processedImage
    }
}
