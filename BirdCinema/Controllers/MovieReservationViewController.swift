//
//  MovieReservationViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MovieReservationViewController: UIViewController {
  
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var adultCountLabel: UILabel!
    @IBOutlet weak var youthCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    
    let morningItems = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"]
    let afternoonItems = ["13:00", "14:00", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "19:30", "20:00", "20:30", "21:00", "22:00"]
    let adultPrice = 14000
    let youthPrice = 10000
    var totalPrice = 0
    
    var selectedIndexPath: IndexPath?
    var selectedTime: String?
    var movieTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register() // 셀 등록 메서드 호출
        configureUI()
        configureCollectionView()
    }
    
    // MARK: - Configure
    func configureUI() {
//        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // 날짜 선택 범위 설정
        let currentDate = Date()
        datePicker.minimumDate = currentDate
        
        if let oneMonthAfterDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
            datePicker.maximumDate = oneMonthAfterDate
        }
    
        // 영화 제목
        titleLabel.text = movieTitle
        
        paymentButton.layer.cornerRadius = 20
        paymentButton.clipsToBounds = true
        
    }
    
    func configureCollectionView() {
        // UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 컬렉션 뷰 설정
        timeCollectionView.collectionViewLayout = layout
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
    }
    
    func register() {
        timeCollectionView.register(UINib(nibName: "TimeCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        timeCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    // MARK: - CountButton
    func updateTotalPrice() {
        guard let adultCount = Int(adultCountLabel.text ?? "0"),
              let youthCount = Int(youthCountLabel.text ?? "0") else { return }
        
        totalPrice = (adultPrice * adultCount) + (youthPrice * youthCount)

        totalPriceLabel.text = totalPrice.formattedPriceWithWon()
    }
    
    // adultCountLabel 값이 변경
    func adultCountDidChange() {
        updateTotalPrice()
    }
    
    // youthCountLabel 값이 변경
    func youthCountDidChange() {
        // 총 가격 업데이트
        updateTotalPrice()
    }
    
    @IBAction func tappedAdultMinus(_ sender: UIButton) {
        guard var count = Int(adultCountLabel.text ?? "0") else { return }
        if count > 0 {
            count -= 1
            adultCountLabel.text = "\(count)"
            adultCountDidChange()
        }
    }
    
    @IBAction func tappedAdultPlus(_ sender: UIButton) {
        guard var count = Int(adultCountLabel.text ?? "0") else { return }
        count += 1
        adultCountLabel.text = "\(count)"
        adultCountDidChange()
    }
    
    @IBAction func tappedYouthMinus(_ sender: UIButton) {
        guard var count = Int(youthCountLabel.text ?? "0") else { return }
        
        if count > 0 {
            count -= 1
            youthCountLabel.text = "\(count)"
            youthCountDidChange()
        }
    }
    
    @IBAction func tappedYouthPlus(_ sender: UIButton) {
        guard var count = Int(youthCountLabel.text ?? "0") else { return }
        count += 1
        youthCountLabel.text = "\(count)"
        youthCountDidChange()
    }
    
    // MARK: - PayButton
    @IBAction func tappedPayButton(_ sender: UIButton) {
        // 선택된 날짜와 시간, 그리고 총 가격을 가져옵니다.
        let movieTitle = titleLabel.text ?? ""
        let selectedDate = formatDate(date: datePicker.date)
        let selectedTime = selectedTime ?? ""
        let adultCount = Int(adultCountLabel.text ?? "0") ?? 0
        let youthCount = Int(youthCountLabel.text ?? "0") ?? 0
        let totalPrice = totalPrice
    
        // AlertAction
        if selectedTime.isEmpty {
            // 알림창을 표시합니다.
            let alertController = UIAlertController(title: "Notice", message: "시간을 선택해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if totalPrice == 0 {
            let alertController = UIAlertController(title: "Notice", message: "인원을 선택해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: "Notice", message: "결제하시겠습니까?", preferredStyle: .alert)

        // 확인 액션 추가
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 예약 데이터 생성 후 추가
            let reservationData = ReservationData(movieTitle: movieTitle, date: selectedDate, time: selectedTime, adultCount: adultCount, youthCount: youthCount, totalPrice: totalPrice)
            ReservationManager.shared.addReservation(reservationData)
            
            // 확인용
            print("예약 데이터: \(reservationData)")
        }

        // 취소 액션 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        // 알림창에 액션 추가
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // 알림창 표시
        present(alertController, animated: true, completion: nil)


    }
    
    func formatDate(date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}

extension MovieReservationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // 오전과 오후 섹션
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? morningItems.count : afternoonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as? TimeCell  else { return UICollectionViewCell() }
        
        let items = indexPath.section == 0 ? morningItems : afternoonItems
        cell.titleLabel.text = items[indexPath.item]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) // 헤더 높이 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else { return UICollectionReusableView() }
            
            // 헤더 뷰 설정
            headerView.titleLabel.text = indexPath.section == 0 ? "오전" : "오후"
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 셀의 스타일 변경
        if let cell = collectionView.cellForItem(at: indexPath) as? TimeCell {
            cell.borderView.backgroundColor = .systemIndigo
            print("Selected time: \(cell.titleLabel.text ?? "")")
            selectedTime = cell.titleLabel.text ?? ""
        }
        
        // 이전에 선택된 셀이 있다면 선택 해제
        if collectionView == collectionView {
            if let selectedIndexPath = selectedIndexPath {
                if let cell = collectionView.cellForItem(at: selectedIndexPath) as? TimeCell {
                    cell.borderView.backgroundColor = .clear // 이전에 선택된 셀의 스타일 초기화
                }
            }
        }
        // 선택된 셀의 인덱스 저장
        selectedIndexPath = indexPath
    }
}

