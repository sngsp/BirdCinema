//
//  ProfileCell.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/24.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureUI()
    }
    
    func configureUI() {
        profileView.layer.cornerRadius = 16
        profileView.clipsToBounds = true
        
        profileView.layer.borderWidth = 1
        profileView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
}
