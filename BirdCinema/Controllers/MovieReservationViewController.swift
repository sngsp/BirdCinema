//
//  MovieReservationViewController.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MovieReservationViewController: UIViewController {
  
    @IBOutlet weak var collectionView: UICollectionView!
    let items = ["9:30", "11:00", "12:30", "14:00", "15:30", "17:00", "18:30", "20:00", "21:30", "23:00"]
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
        collectionView.showsHorizontalScrollIndicator = false
        
        // UICollectionViewFlowLayout 설정
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
   
}

extension MovieReservationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
       // MARK: UICollectionViewDataSource
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return items.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
           cell.titleLabel.text = items[indexPath.item]
           
           // 선택한 날짜가 있는 경우 강조
           if selectedIndexPath == indexPath {
               cell.titleLabel.textColor = UIColor.systemIndigo // 강조하는 색상
           } else {
               cell.titleLabel.textColor = UIColor.black // 일반 색상
           }
           
           return cell
       }
       
       // MARK: UICollectionViewDelegate
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // 선택한 항목 처리
           print("Selected item: \(items[indexPath.item])")
           
           // 선택한 날짜 강조
           selectedIndexPath = indexPath
           collectionView.reloadData()
       }
       
       // MARK: UICollectionViewDelegateFlowLayout
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 70, height: collectionView.frame.size.height)
       }
}
