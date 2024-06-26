//
//  MainCollectionViewCell.swift
//  BirdCinema
//
//  Created by 김시종 on 4/22/24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionMainLabel: UILabel!
    @IBOutlet weak var collectionSubLabel: UILabel!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var collectionMainImage: UIImageView!
    
    var cellConfiguration: ((MainCollectionViewCell) -> Void)?

    
    @IBAction func collectionButtonTapped(_ sender: UIButton) {
        // 클로저 호출
        cellConfiguration?(self)
    }
}
