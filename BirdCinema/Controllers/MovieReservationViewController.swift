//
//  MovieReservationViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MovieReservationViewController: UIViewController {
  
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let morningItems = ["9:30", "10:00", "10:30", "11:00", "11:30", "12:00"]
    let afternoonItems = ["12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30"]
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
    }
    
    
    func configureUI() {
        // self.navigationController?.navigationBar.tintColor = .white
        // self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // 오늘 날짜 이전의 날짜는 선택할 수 없도록 설정
        datePicker.minimumDate = Date()
    }
    
    func configureCollectionView() {
        // UICollectionViewCell nib 파일 등록
        let nib = UINib(nibName: "TimeCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TimeCell")
        
        // UICollectionView 설정
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // allowsMultipleSelection
        collectionView.allowsMultipleSelection = false

        // UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0 // 셀 간의 수평 간격
        layout.minimumLineSpacing = 0 // 셀 간의 수직 간격
        collectionView.collectionViewLayout = layout
    }
   
}

extension MovieReservationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 오전과 오후 두 개의 섹션을 반환
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 각 섹션에 따라 아이템 개수 반환
        return section == 0 ? morningItems.count : afternoonItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
        let items = indexPath.section == 0 ? morningItems : afternoonItems
        cell.titleLabel.text = items[indexPath.item]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 이전에 선택된 셀이 있다면 선택 해제
        if let selectedIndexPath = selectedIndexPath {
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
            if let cell = collectionView.cellForItem(at: selectedIndexPath) as? TimeCell {
                cell.titleLabel.textColor = .black // 이전에 선택된 셀의 텍스트 색상 원래대로 변경
                cell.titleLabel.font = UIFont.systemFont(ofSize: 16) // 이전에 선택된 셀의 텍스트 크기 원래대로 변경
            }
        }
        
        // 선택된 셀의 정보 출력
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TimeCell
        print("Selected Time:", selectedCell.titleLabel.text ?? "")
        
        // 선택된 셀의 텍스트 색상과 크기 변경
        selectedCell.titleLabel.textColor = .systemIndigo
        selectedCell.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        // 선택된 셀의 indexPath 저장
        selectedIndexPath = indexPath
    }

    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 한 줄에 4개의 셀이 보이도록 크기 설정
        let width = collectionView.bounds.width / 4
        let height: CGFloat = 50 // 적절한 높이 설정
        return CGSize(width: width, height: height)
    }
}
