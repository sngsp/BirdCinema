//
//  UpRateCollectionViewCell.swift
//  BirdCinema
//
//  Created by 김시종 on 4/23/24.
//

import UIKit

class UpRateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var upRateCollectionImage: UIImageView!
    @IBOutlet weak var upRateCollectionMainLabel: UILabel!
    @IBOutlet weak var upRateCollectionSubLabel: UILabel!
    @IBOutlet weak var upRateButton: UIButton!
    
    var cellConfiguration: ((UpRateCollectionViewCell) -> Void)?
    
    @IBAction func collectionButtonTapped(_ sender: UIButton) {
        // 클로저 호출
        cellConfiguration?(self)
    }
    
}
