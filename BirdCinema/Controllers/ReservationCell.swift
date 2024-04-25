//
//  ReservationCell.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/23.
//

import UIKit

class ReservationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ reservation: ReservationData) {
        let adultCount = reservation.adultCount
        let youthCount = reservation.youthCount
        let date = reservation.date
        let time = reservation.time
        
        titleLabel.text = reservation.movieTitle
        dateLabel.text = "\(date) \(time)"
        
        if adultCount == 0 {
            countLabel.text = "\(youthCount)명 청소년"
        } else if youthCount == 0 {
            countLabel.text = "\(adultCount)명 일반"
        }else {
            countLabel.text = "\(adultCount)명 일반\n\(youthCount)명 청소년"
        }
    }
    
    
}
