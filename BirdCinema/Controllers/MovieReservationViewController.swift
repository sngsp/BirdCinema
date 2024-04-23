//
//  MovieReservationViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MovieReservationViewController: UIViewController {
  
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeCollectionView: UICollectionView!

    
    let morningItems = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"]
    let afternoonItems = ["13:00", "14:00", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "19:30", "20:00", "20:30", "21:00", "22:00"]
    
    var selectedIndexPath: IndexPath?
    var selectedIndexPathForMorning: IndexPath?
    var selectedIndexPathForAfternoon: IndexPath?
    // 선택된 데이터를 저장할 변수 선언
    var selectedData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells() // 셀 등록 메서드 호출
        configureUI()
        configureCollectionView()
    }
    
    func configureUI() {
        //        self.navigationController?.navigationBar.tintColor = .white
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // 오늘 날짜 이전의 날짜는 선택할 수 없도록 설정
        datePicker.minimumDate = Date()
    }
    
    func configureCollectionView() {
        // UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0 // 셀 간의 수평 간격
        layout.minimumLineSpacing = 0 // 셀 간의 수직 간격
        // 컬렉션 뷰 설정
        timeCollectionView.collectionViewLayout = layout
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        
        timeCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
    }
    
    func registerCells() {
        // TimeCell을 "TimeCell" 식별자와 함께 등록
        timeCollectionView.register(UINib(nibName: "TimeCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
        
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            
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
            cell.borderView.backgroundColor = .systemIndigo // 선택된 셀의 배경색을 변경하거나 원하는 스타일을 적용
            print("Selected time: \(cell.titleLabel.text ?? "")") // 선택된 셀의 데이터 출력
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
        
        // 여기서 선택된 셀을 이용하여 예매 등의 작업
    }
}
