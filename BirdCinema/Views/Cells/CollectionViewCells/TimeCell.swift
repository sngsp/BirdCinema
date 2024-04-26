//
//  TimeCell.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/22.
//

import UIKit

class TimeCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }
    
    func configureCell() {
        // 메뉴 cell 테두리 설정
        borderView.layer.cornerRadius = 10
        borderView.clipsToBounds = true
        
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.systemGray5.cgColor
        borderView.backgroundColor = .clear
    }
}
