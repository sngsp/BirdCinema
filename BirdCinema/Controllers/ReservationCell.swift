//
//  ReservationCell.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/23.
//

import UIKit

class ReservationCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
