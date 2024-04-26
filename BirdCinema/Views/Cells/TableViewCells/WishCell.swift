//
//  WishCell.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/26.
//

import UIKit

class WishCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ movie: WishMovieData) {
        titleLabel.text = movie.title
        dateLabel.text = movie.date
    }
}
