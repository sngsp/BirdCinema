//
//  ProfileCell.swift
//  BirdCinema
//
//  Created by 정유진 on 2024/04/24.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    var logOutButtonAction: (() -> Void)?
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureUI()
    }
    
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        logOutButtonAction?()
    }
    
    func configureUI() {
        profileView.layer.cornerRadius = 16
        profileView.clipsToBounds = true
        
        profileView.layer.borderWidth = 1
        profileView.layer.borderColor = UIColor.systemGray.cgColor
        
        logOutButton.layer.cornerRadius = 16
        logOutButton.clipsToBounds = true
    }
    
}
